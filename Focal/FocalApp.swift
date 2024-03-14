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
    @NSApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var timerViewModel = TimerViewModel()

    init() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (success, error) in }
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

final class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        if let window = NSApplication.shared.windows.first {
            window.collectionBehavior = .fullScreenNone
        }
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        true
    }
}

