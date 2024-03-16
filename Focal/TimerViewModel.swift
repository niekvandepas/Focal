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
    @Published var timeRemaining = 25 * 60
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

    private func scheduleNotification(_ finishedTimerState: TimerState) {
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
        content.categoryIdentifier = "TIMER_EXPIRED"
        let deliveryDate = Date()

        let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: deliveryDate), repeats: false)
        let request = UNNotificationRequest(identifier: "com.niekvdpas.FocalTimeUp", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            } else {
                print("Notification scheduled successfully!")
            }
        }
    }

}

