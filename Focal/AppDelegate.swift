//
//  AppDelegate.swift
//  Focal
//
//  Created by Niek van de Pas on 19/03/2024.
//

import SwiftUI
import UserNotifications

final class AppDelegate: NSObject, NSApplicationDelegate, @preconcurrency UNUserNotificationCenterDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        if let window = NSApplication.shared.windows.first {
            window.collectionBehavior = .fullScreenNone
        }

        UNUserNotificationCenter.current().delegate = self

        ensureMainWindowIsOpen()
        disableWindowResizing()
    }

    func applicationDidBecomeActive(_ notification: Notification) {
        ensureMainWindowIsOpen()
    }

    @MainActor
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if response.actionIdentifier == "START_NEXT_TIMER" {
            TimerViewModel.shared.startTimer()
        }
        completionHandler()
    }

    /// Opens the main window (the timer window) if it is not already open
    @MainActor
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

    /// Disables window rezising for all application windows
    @MainActor
    private func disableWindowResizing() {
        NSApp.windows.forEach { $0.styleMask.remove(.resizable) }
    }
}
