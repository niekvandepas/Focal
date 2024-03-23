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
    @Published var timeRemaining = 2
#else
    @Published var timeRemaining = 25 * 60
#endif
    @Published var timerIsRunning = false
    @Published var timerState: TimerState = .work

    private var timer: AnyCancellable?

    init() {
        timer = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                guard self.timerIsRunning else { return }
                if self.timeRemaining > 0 {
                    self.timeRemaining -= 1
                } else {
                    self.scheduleNotification(self.timerState)
                    self.timerState.toggle()
                    #if os(macOS)
                    if !SettingsViewModel.shared.startNextTimerAutomatically {
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
                        self.timeRemaining = 5 * 60
                    }
                }
            }
    }
    
    func toggleTimer() {
        timerIsRunning.toggle()
    }
    
    func startTimer() {
        timerIsRunning = true
    }
    
    func pauseTimer() {
        timerIsRunning = false
    }
    
    func resetTimer() {
        timerState = .work
        timeRemaining = 25 * 60
        timerIsRunning = false
    }

    var timerIsFull: Bool {
        switch self.timerState {
        case .work:
            return timeRemaining == 25 * 60
        case .rest:
            return timeRemaining == 5 * 60
        }
    }

    private func scheduleNotification(_ finishedTimerState: TimerState) {
        let content = createNotificationContent(for: finishedTimerState)

        // show this notification 0.1 seconds from now
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        // add our notification request
        UNUserNotificationCenter.current().add(request) { error in
            if error != nil {print(error ?? "")}
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

        if !SettingsViewModel.shared.startNextTimerAutomatically {
            content.categoryIdentifier = "TIMER_EXPIRED"
        }
        return content
    }
}

