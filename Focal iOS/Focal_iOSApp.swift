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
    @StateObject var settingsManager = SettingsManager.shared
    let notificationDelegate = NotificationDelegate()

    init() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (success, error) in }
        UNUserNotificationCenter.current().delegate = notificationDelegate
    }

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ZStack {
                    HStack(alignment: .top) {
                        Spacer()
                        SettingsIcon()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)

                    TimerView()
                        .environmentObject(settingsManager)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                }
                .background(Color.accentColor)
            }
            .frame(maxHeight: .infinity)
            .background(ignoresSafeAreaEdges: .all)
        }
    }
}
