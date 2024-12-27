//
//  NotificationManager.swift
//  Focal
//
//  Created by Niek van de Pas on 17/04/2024.
//

import UserNotifications

struct NotificationManager {
    static func scheduleNotification(for triggerDate: Date, withSound notificationSound: NotificationSound?, withTimerState timerState: TimerState) async -> Bool {
        guard await SettingsManager.shared.notificationsAreOn else { return true }

        let content = await createNotificationContent(for: timerState, withSound: notificationSound)
        let category = createNotificationCategory()
        UNUserNotificationCenter.current().setNotificationCategories([category])

        let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: triggerDate), repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        return await withCheckedContinuation { continuation in
            UNUserNotificationCenter.current().add(request) { error in
                if error == nil {
                    continuation.resume(returning: true)
                } else {
                    continuation.resume(returning: false)
                }
            }
        }
    }

    static func removeAllNotificationRequests() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }

    private static func createNotificationContent(for finishedTimerState: TimerState, withSound notificationSound: NotificationSound?) async -> UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        switch finishedTimerState {
        case .work:
            content.title = "Time for a break!"
            content.body = "Your Pomodoro session has ended. Time to take a break!"
        case .rest:
            content.title = "Break's over!"
            content.body = "Time to get back to work!"
        }

        if let notificationSound = notificationSound {
            let notificationFileName = notificationSound.fileName
            let sound = UNNotificationSound(named:UNNotificationSoundName(rawValue: notificationFileName))
            content.sound = sound
        }

        if await !SettingsManager.shared.startNextTimerAutomatically {
            content.categoryIdentifier = "TIMER_EXPIRED"
        }
        return content
    }

    private static func createNotificationCategory() -> UNNotificationCategory {
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
