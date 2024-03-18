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
        self.menuBarExtra()

        WindowGroup {
            ZStack {
                Color.accentColor
                TimerView(viewModel: timerViewModel)
                    .frame(width: 300, height: 400)
            }
        }
        .defaultSize(width: 300, height: 400)
        .windowResizability(.contentSize)
    }

    private func menuBarExtra() -> some Scene {
        if timerViewModel.timerIsRunning {
            return MenuBarExtra("Focal", image: timerViewModel.timerState == .work ? "play.circle.workBlue" : "play.circle.workGreen") {
                AppMenu(viewModel: timerViewModel)
            }
        }
        else {
            let systemImage = timerViewModel.timerIsFull ? "stop.circle" : "pause.circle"

            return MenuBarExtra("Focal", systemImage: systemImage) {
                AppMenu(viewModel: timerViewModel)
            }
        }
    }
}

final class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        if let window = NSApplication.shared.windows.first {
            window.collectionBehavior = .fullScreenNone
        }

        ensureMainWindowIsOpen()
    }

    func applicationDidBecomeActive(_ notification: Notification) {
        ensureMainWindowIsOpen()
    }

    /// Ensures the main window (the timer window) is open at app launch.
    private func ensureMainWindowIsOpen() {
        // If fewer than 2 windows are open, that means only the menu bar item 'window' is open,
        // and we need to 'click' the 'New Window' menu bar item to ensure the timer window is open.
        guard NSApplication.shared.windows.count < 2,
              let mainMenu = NSApp.mainMenu,
              let fileMenu = mainMenu.item(withTitle: "File")?.submenu,
              let newWindowMenuItem = fileMenu.item(withTitle: "New Window"),
              let action = newWindowMenuItem.action
        else {
            return
        }

        // Programmatically trigger the menu item
        NSApp.sendAction(action, to: newWindowMenuItem.target, from: nil)
        newWindowMenuItem.isEnabled = false
    }

}

