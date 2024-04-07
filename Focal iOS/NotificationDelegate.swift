//
//  AppDelegate.swift
//  Focal
//
//  Created by Niek van de Pas on 19/03/2024.
//

import SwiftUI
import UserNotifications
import UIKit

final class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .list, .sound, .badge])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if response.actionIdentifier == "START_NEXT_TIMER" {
            // HACK: SceneDelegate.correctSuspendedTimerState, which calculates the time since the app was last closed and then pauses the timer,
            // conflicts with the handling of this notification action, which start the timer,
            // so we delay by 750 milliseconds to ensure the timer is started after it is paused.
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(750)) {
                TimerViewModel.shared.startTimer()
            }
        }
        completionHandler()
    }

//    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
//    }

    // this gets called when the app is in the foreground
//    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
//        return UNNotificationPresentationOptions()
//    }
//
//    func userNotificationCenter(_ center: UNUserNotificationCenter, openSettingsFor notification: UNNotification?) {
//    }

}

