//
//  TimerViewModel.swift
//  Focal
//
//  Created by Niek van de Pas on 12/03/2024.
//

import SwiftUI
import Combine

@MainActor
class TimerViewModel: ObservableObject {
    static let shared = TimerViewModel()
    @Published var timeRemaining: Int
    @Published private var _timerIsRunning = false
    @Published var confettiCounter: Int = 0

    @Published var workTimerName: String = "Work"
    @Published var restTimerName: String = "Rest"

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
        self.timeRemaining = settingsManager.workTimerDuration
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
        timeRemaining = settingsManager.workTimerDuration
        timerIsRunning = false
        completedSessions = 0
        self.updateUserDefaults()
    }

    func skipBreakTimer() {
        timerState = .work
        self.resetTimerDuration()
        NotificationManager.removeAllNotificationRequests()
        completedSessions += 1
        timerIsRunning = settingsManager.continuousMode
    }

    func updateUserDefaults() {
        if let userDefaults = UserDefaults(suiteName: Constants.UD_GROUP_NAME) {
            userDefaults.set(timeRemaining, forKey: Constants.UD_TIME_REMAINING)
            userDefaults.set(timerIsRunning, forKey: Constants.UD_TIMER_IS_RUNNING)
            userDefaults.set(timerState.rawValue, forKey: Constants.UD_TIMER_STATE)
            userDefaults.set(getNextTimerState().rawValue, forKey: Constants.UD_NEXT_TIMER_STATE)
            userDefaults.set(settingsManager.showTimeLeft, forKey: Constants.UD_SHOW_TIME_LEFT_SETTING)
        }
    }

    func resetTimerDuration() {
        timeRemaining = timerState == .work ? settingsManager.workTimerDuration : settingsManager.restTimerDuration
        timerIsRunning = false
    }

    /// Returns true if the timer is at its full work duration, indicating it is reset or not started.
    var timerIsFull: Bool {
        return timeRemaining == settingsManager.workTimerDuration
    }

    var timeRemainingFormatted: String {
        "\(timeRemaining / 60):\(String(format: "%02d", timeRemaining % 60))"
    }

    func getNextTimerState() -> TimerState {
        switch self.timerState {
        case .work:
            // completedSessions only rolls over after the break, so we need to check for sessionGoal - 1
            return self.completedSessions >= settingsManager.sessionGoal - 1 ? .longRest : .rest
        case .rest:
            return .work
        case .longRest:
            return .work
        }
    }

    private func initializeTimer() {
        self.timer = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink(receiveValue: self.handleTimerTick)
    }

    private func handleTimerTick(_: Date) {
        Task {
            if self.timerIsRunning && !self.notificationScheduled {
                await self.scheduleTimerFinishedNotification()
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
        if !SettingsManager.shared.continuousMode {
            self.pauseTimer()
        }

        if SettingsManager.shared.showAppOnTimerElapse {
            NSApplication.shared.activate(ignoringOtherApps: true)

            if let mainWindow = NSApplication.shared.windows.first(where: { $0.title == "Focal" }) {
                mainWindow.makeKeyAndOrderFront(nil)
            }
        }
        #endif
        #if os(iOS)
        self.pauseTimer()
        #endif

        if settingsManager.continuousMode {
            // If the timer is in this 'continuous mode',
            // we need to schedule the next notification immediately when the timer elapses.
            // Normally, this is done when the timer is manually unpaused,
            // but that never happens in this mode.
            Task {
                await self.scheduleTimerFinishedNotification()
            }
        }

        let nextTimerState = getNextTimerState()

        switch self.timerState {
        case .rest:
            self.completedSessions += 1
            self.timeRemaining = settingsManager.workTimerDuration
        case .work:
            // The completedSessions counter only rolls over after the break,
            // so we need to check for sessionGoal - 1 here.
            if completedSessions == settingsManager.sessionGoal - 1 {
                showConfetti()
            }
            self.timeRemaining = getTimerDuration(forTimerState: nextTimerState)
        case .longRest:
            self.resetTimer()
        }

        self.timerState = nextTimerState
        self.updateUserDefaults()
    }

    private func getTimerDuration(forTimerState timerState: TimerState) -> Int {
        switch timerState {
        case .work:
            return settingsManager.workTimerDuration
        case .rest:
            return settingsManager.restTimerDuration
        case .longRest:
            return settingsManager.longRestTimerDuration
        }
    }

    private func scheduleTimerFinishedNotification() async {
        let nextTimerState = getNextTimerState()
        let notificationScheduled = await NotificationManager.scheduleNotification(
            for: Date().addingTimeInterval(TimeInterval(self.timeRemaining)),
            withSound: NotificationSound(rawValue: settingsManager.notificationSound) ?? .bell,
            currentTimerState: self.timerState,
            nextTimerState: nextTimerState)

        self.notificationScheduled = notificationScheduled
    }

    private func showConfetti() {
        // Incrementing the counter causes confetti to be shown
        self.confettiCounter += 1
    }
}

