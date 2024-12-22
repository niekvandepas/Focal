//
//  TimerViewModel.swift
//  Focal
//
//  Created by Niek van de Pas on 12/03/2024.
//

import SwiftUI
import Combine

class TimerViewModel: ObservableObject {
    static let shared = TimerViewModel()
#if DEBUG
    @Published var timeRemaining = 3
#else
    @Published var timeRemaining = 25 * 60
#endif
    @Published private var _timerIsRunning = false
    @Published var confettiCounter: Int = 0

    @Published var workTimerName: String = "Work"
    @Published var restTimerName: String = "Rest"

    #if DEBUG
    private let workTimerDuration = 5
    private let restTimerDuration =  3
    #else
    private let workTimerDuration = 25 * 60
    private let restTimerDuration =  5 * 60
    #endif

    var timerIsRunning: Bool {
        get { return _timerIsRunning }
        set {
            if newValue == true {
                self.initializeTimer()
            }
            else {
                self.timer = nil
                NotificationManager.removeAllNotificationRequests()
                self.notificationScheduled = false
            }
            _timerIsRunning = newValue
        }
    }
    @Published var timerState: TimerState = .work
    @Published var completedSessions = 0
    var notificationScheduled = false
    private let settingsManager = SettingsManager.shared

    private var timer: AnyCancellable?

    init() {
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
        timeRemaining = self.workTimerDuration
        timerIsRunning = false
        completedSessions = 0
        self.updateUserDefaults()
    }

    func skipTimer() {
        timerState.toggle()
        self.resetTimerDuration()
        NotificationManager.removeAllNotificationRequests()
        completedSessions += 1
        timerIsRunning = settingsManager.startNextTimerAutomatically
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
        timeRemaining = timerState == .work ? self.workTimerDuration : self.restTimerDuration
        timerIsRunning = false
    }

    /// Whether or not the timer is at 25 minutes
    var timerIsFull: Bool {
        return timeRemaining == self.workTimerDuration
    }

    var timeRemainingFormatted: String {
        "\(timeRemaining / 60):\(String(format: "%02d", timeRemaining % 60))"
    }

    private func initializeTimer() {
        self.timer = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink(receiveValue: self.handleTimerTick)
    }

    private func handleTimerTick(_: Date) {
        if self.timerIsRunning && !self.notificationScheduled {
            NotificationManager.scheduleNotification(for: Date().addingTimeInterval(TimeInterval(self.timeRemaining)), withSound: NotificationSound(rawValue: settingsManager.notificationSound) ?? .bell, withTimerState: self.timerState) { notificationScheduled in
                self.notificationScheduled = notificationScheduled
            }
        }
        if self.timeRemaining > 0 {
            self.timeRemaining -= 1
        } else {
            self.handleTimerFinished()
        }
    }

    private func handleTimerFinished() {
        #if os(macOS)
        if !SettingsManager.shared.startNextTimerAutomatically {
            self.pauseTimer()
        }
        #endif
        #if os(iOS)
        self.pauseTimer()
        #endif

        switch self.timerState {
        case .rest:
            self.completedSessions += 1
            self.timeRemaining = self.workTimerDuration
        case .work:
            // The completedSessions counter only rolls over after the break,
            // so we need to check for sessionGoal - 1 here.
            if completedSessions == settingsManager.sessionGoal - 1 {
                showConfetti()
            }
            self.timeRemaining = self.restTimerDuration
        }

        self.timerState.toggle()
        self.updateUserDefaults()
    }

    private func showConfetti() {
        // Incrementing the counter causes confetti to be shown
        self.confettiCounter += 1
    }
}

