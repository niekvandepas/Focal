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

        ensureMainWindowIsOpen()
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        true
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

