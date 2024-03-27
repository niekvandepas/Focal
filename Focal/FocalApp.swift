//
//  FocalApp.swift
//  Focal
//
//  Created by Niek van de Pas on 11/03/2024.
//

import SwiftUI
import UserNotifications
import KeyboardShortcuts

@main
struct FocalApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var timerViewModel = TimerViewModel.shared
    @StateObject var settingsManager = SettingsManager.shared

    init() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (success, error) in }
    }

    var body: some Scene {
        self.menuBarExtra()

        WindowGroup {
            ZStack {
                Color.accentColor
                TimerView()
                    .frame(width: 300, height: 400)
                    .environmentObject(settingsManager)
                    .onAppear {
                        KeyboardShortcuts.onKeyUp(for: .toggleTimer) { [self] in
                            timerViewModel.toggleTimer()

                            if (settingsManager.globalShortcutBringsAppToFront) {
                                if #available(macOS 14.0, *) {
                                    NSApp.activate()
                                }
                                else {
                                    NSApplication.shared.activate(ignoringOtherApps: true)
                                }
                            }
                        }
                    }
            }
        }
        .defaultSize(width: 300, height: 400)
        .windowResizability(.contentSize)

        Settings {
            SettingsView(settingsManager: settingsManager)
                .environmentObject(settingsManager)
                .frame(width: 380, height: 184)
        }
    }

    private func menuBarExtra() -> some Scene {
        if timerViewModel.timerIsRunning {
            return MenuBarExtra("Focal", image: timerViewModel.timerState == .work ? "play.circle.workBlue" : "play.circle.workGreen") {
                AppMenu()
            }
        }
        else {
            let systemImage = timerViewModel.timerIsFull ? "stop.circle" : "pause.circle"

            return MenuBarExtra("Focal", systemImage: systemImage) {
                AppMenu()
            }
        }
    }
}
