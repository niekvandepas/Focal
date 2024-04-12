//
//  TimerViewModel.swift
//  Focal
//
//  Created by Niek van de Pas on 12/03/2024.
//

import SwiftUI
import Combine
import UserNotifications

class TimerViewModel: ObservableObject {
    static let shared = TimerViewModel()
#if DEBUG
    @Published var timeRemaining = 3
#else
    @Published var timeRemaining = 25 * 60
#endif
    @Published var timerIsRunning = false
    @Published var timerState: TimerState = .work
    @Published var completedSessions = 0
    var notificationScheduled = false
    private let settingsManager = SettingsManager.shared

    private var timer: AnyCancellable?

    init() {
        self.updateUserDefaults()

        timer = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink(receiveValue: self.handleTimerTick)
    }
    
    func toggleTimer() {
        timerIsRunning.toggle()
        self.updateUserDefaults()
    }
    
    func startTimer() {
        timerIsRunning = true
        self.updateUserDefaults()
    }
    
    func pauseTimer() {
        timerIsRunning = false
        self.updateUserDefaults()
    }
    
    func resetTimer() {
        timerState = .work
        timeRemaining = 25 * 60
        timerIsRunning = false
        completedSessions = 0
        self.updateUserDefaults()
    }

    func updateUserDefaults() {
        if let userDefaults = UserDefaults(suiteName: Constants.UD_GROUP_NAME) {
            userDefaults.set(timeRemaining, forKey: Constants.UD_TIME_REMAINING)
            userDefaults.set(timerIsRunning, forKey: Constants.UD_TIMER_IS_RUNNING)
            userDefaults.set(timerState.rawValue, forKey: Constants.UD_TIMER_STATE)
            userDefaults.set(settingsManager.showTimeLeft, forKey: Constants.UD_SHOW_TIME_LEFT_SETTING)
        }
    }

    func resetTimerDuration() {
        timeRemaining = timerState == .work ? 25 * 60 : 5 * 60
        timerIsRunning = false
    }

    var timerIsFull: Bool {
        return timeRemaining == 25 * 60
    }

    var timeRemainingFormatted: String {
        "\(timeRemaining / 60):\(String(format: "%02d", timeRemaining % 60))"
    }

    private func handleTimerTick(_: Date) -> Void {
        guard self.timerIsRunning else { return }
        if self.timerIsRunning && !self.notificationScheduled {
            self.scheduleNotification()
        }
        if self.timeRemaining > 0 {
            self.timeRemaining -= 1
        } else {
            self.timerState.toggle()
            #if os(macOS)
            if !SettingsManager.shared.startNextTimerAutomatically {
                self.pauseTimer()
            }
            #endif
            #if os(iOS)
            self.pauseTimer()
            #endif

            switch self.timerState {
            case .work:
                self.timeRemaining = 25 * 60
            case .rest:
                self.completedSessions += 1
                self.timeRemaining = 5 * 60
            }
            self.updateUserDefaults()
        }
    }

    private func scheduleNotification() {
        let content = createNotificationContent(for: self.timerState)
        let category = createNotificationCategory()
        UNUserNotificationCenter.current().setNotificationCategories([category])

        let triggerTime = Date().addingTimeInterval(TimeInterval(self.timeRemaining))
        let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: triggerTime), repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        // add our notification request
        UNUserNotificationCenter.current().add(request) { error in
            if error == nil {
                self.notificationScheduled = true
            }
            else {
                print(error ?? "")
            }
        }
    }

    private func createNotificationContent(for finishedTimerState: TimerState) -> UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        switch finishedTimerState {
        case .work:
            content.title = "Time for a break!"
            content.body = "Your Pomodoro session has ended. Time to take a break!"
        case .rest:
            content.title = "Break's over!"
            content.body = "Time to get back to work!"
        }
        content.sound = .default

        if !SettingsManager.shared.startNextTimerAutomatically {
            content.categoryIdentifier = "TIMER_EXPIRED"
        }
        return content
    }

    private func createNotificationCategory() -> UNNotificationCategory {
        let startNextTimerAction = UNNotificationAction(identifier: "START_NEXT_TIMER",
                                                         title: "Start Next Timer",
                                                         options: .foreground)
        let category = UNNotificationCategory(identifier: "TIMER_EXPIRED",
                                              actions: [startNextTimerAction],
                                              intentIdentifiers: [],
                                              options: [])
        return category
    }
}

