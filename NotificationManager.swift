//
//  NotificationManager.swift
//  Focal
//
//  Created by Niek van de Pas on 17/04/2024.
//

import UserNotifications

struct NotificationManager {
    static func scheduleNotification(for triggerDate: Date, withSound notificationSound: NotificationSound?, currentTimerState: TimerState, nextTimerState: TimerState) async -> Bool {
        // We return true here despite the notification not being scheduled when notifications are disabled,
        // since the downstream business logic uses this function's return value
        // to determine whether or not to call this function again.
        // Returning 'false' here would result in many unnecessary calls to this function.
        guard await SettingsManager.shared.notificationsAreOn else { return true }

        let content = await createNotificationContent(for: currentTimerState, withSound: notificationSound)
        let category = createNotificationCategory(nextTimerState: nextTimerState)
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

    /// Updates the notification sound for all pending notifications.
    ///
    /// - Parameter newSound: The new sound to set for all notifications.
    static func updateNotificationSound(to newSound: NotificationSound) {
        let notificationCenter = UNUserNotificationCenter.current()

        notificationCenter.getPendingNotificationRequests { requests in
            let identifiers = requests.map { $0.identifier }
            notificationCenter.removePendingNotificationRequests(withIdentifiers: identifiers)

            for request in requests {
                let updatedContent = request.content.mutableCopy() as! UNMutableNotificationContent

                let notificationFileName = newSound.fileName
                let newSound = UNNotificationSound(named:UNNotificationSoundName(rawValue: notificationFileName))
                updatedContent.sound = newSound

                let newRequest = UNNotificationRequest(
                    identifier: request.identifier,
                    content: updatedContent,
                    trigger: request.trigger
                )

                notificationCenter.add(newRequest) { error in
                    if let error = error {
                        print("Error re-scheduling notification: \(error)")
                    }
                }
            }
        }
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
        case .longRest:
            content.title = "Break's over!"
            content.body = "Time to get back to work!"
        }

        if let notificationSound = notificationSound {
            let notificationFileName = notificationSound.fileName
            let sound = UNNotificationSound(named:UNNotificationSoundName(rawValue: notificationFileName))
            content.sound = sound
        }

        if await !SettingsManager.shared.continuousMode {
            content.categoryIdentifier = "TIMER_EXPIRED"
        }
        return content
    }

    private static func createNotificationCategory(nextTimerState: TimerState) -> UNNotificationCategory {
        let title: String = switch nextTimerState {
        case .work:
            "Start Work Timer"
        case .rest:
            "Start Break Timer"
        case .longRest:
            "Start Break Timer"
        }

        let startNextTimerAction = UNNotificationAction(identifier: "START_NEXT_TIMER",
                                                         title: title,
                                                         options: .foreground)
        let category = UNNotificationCategory(identifier: "TIMER_EXPIRED",
                                              actions: [startNextTimerAction],
                                              intentIdentifiers: [],
                                              options: [])
        return category
    }
}
