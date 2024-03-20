//
//  Focal_iOSApp.swift
//  Focal iOS
//
//  Created by Niek van de Pas on 19/03/2024.
//

import SwiftUI
import UserNotifications

@main
struct FocalApp: App {
    @StateObject var timerViewModel = TimerViewModel.shared
    let notificationDelegate = NotificationDelegate()

    init() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (success, error) in }
        UNUserNotificationCenter.current().delegate = notificationDelegate
    }

    var body: some Scene {
        WindowGroup {
            ZStack {
                Color.accentColor
                TimerView()
            }
        }
    }
}

