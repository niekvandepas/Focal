//
//  FocalApp.swift
//  Focal
//
//  Created by Niek van de Pas on 11/03/2024.
//

import SwiftUI
import UserNotifications

@main
struct FocalApp: App {
    @StateObject var timerViewModel = TimerViewModel()

    init() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (success, error) in
        }

    }

    var body: some Scene {
        let menuBarImage = timerViewModel.timerIsRunning ? "play.circle" : "pause.circle";

        MenuBarExtra("Focal", systemImage: menuBarImage) {
            AppMenu(viewModel: timerViewModel)
        }
        WindowGroup {
            TimerView(viewModel: timerViewModel)
        }
        .defaultSize(width: 300, height: 200)
    }
}

