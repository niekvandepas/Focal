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
    @StateObject var settingsViewModel = SettingsViewModel.shared
    let notificationDelegate = NotificationDelegate()

    init() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (success, error) in }
        UNUserNotificationCenter.current().delegate = notificationDelegate
    }

    var body: some Scene {
        WindowGroup {
            ZStack {
                HStack(alignment: .top) {
                    Spacer()
                    settingsIcon // TODO make this a view
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)

                TimerView()
                    .environmentObject(settingsViewModel)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            }
            .frame(maxHeight: .infinity)
            .background(Color.accentColor)
            .background(ignoresSafeAreaEdges: .all)
        }
    }

    var settingsIcon: some View {
        HStack {
            Spacer()
            Button(action: {
                timerViewModel.resetTimer()
            }) {
                Image(systemName: "gear")
                    .font(.title)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 16)
                    .foregroundStyle(.primaryButton)
            }
        }
    }

}

