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
    
    private var timer: AnyCancellable?

    init() {
        timer = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                guard self.timerIsRunning else { return }
                if self.timeRemaining > 0 {
                    self.timeRemaining -= 1
                } else {
                    self.timeRemaining = 25 * 60
                    self.timerIsRunning = false
                    self.scheduleNotification()
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
        timeRemaining = 25 * 60
        timerIsRunning = false
    }

    private func scheduleNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Pomodoro Timer Ended"
        content.body = "Your Pomodoro session has ended. Time to take a break!"
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

