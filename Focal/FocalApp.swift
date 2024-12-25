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
        Task {
            do {
                _ = try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound])
                print("here")
            } catch {
                print("there")
            }
        }
    }

    var body: some Scene {
        self.menuBarExtra()

        WindowGroup {
            ZStack {
                Color.appRed
                TimerView()
                    .frame(width: 300, height: 400)
                    .environmentObject(settingsManager)
                    .onAppear {
                        KeyboardShortcuts.onKeyUp(for: .toggleTimer) { [self] in
                            timerViewModel.timerIsRunning.toggle()

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
                .frame(width: 420)
        }
    }

    private func menuBarExtra() -> some Scene {
        // Getting these values from the SettingsManager here causes an infinite loop for some reason,
        // So we use AppStorage directly here.
        @AppStorage("showMenuBarIcon") var showMenuBarIcon = true
        let label = self.menuBarLabel()

        return MenuBarExtra(isInserted: $showMenuBarIcon, content: {AppMenu()}, label: {label})
    }

    private func menuBarLabel() -> AnyView {
        // Getting these values from the SettingsManager here causes an infinite loop for some reason,
        // So we use AppStorage directly here.
        @AppStorage("showTimeLeftInMenuBar") var showTimeLeftInMenuBar = false
        if showTimeLeftInMenuBar {
            return AnyView(Text(timerViewModel.timeRemainingFormatted))
        }
        else {
            if timerViewModel.timerIsRunning {
                return AnyView(Image(timerViewModel.timerState == .work ? "play.circle.workBlue" : "play.circle.workGreen"))
            }

            else {
                let systemImage = timerViewModel.timerIsFull ? "stop.circle" : "pause.circle"
                return AnyView(Image(systemName: systemImage))
            }
        }
    }
}
