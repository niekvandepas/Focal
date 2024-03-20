//
//  AppDelegate.swift
//  Focal
//
//  Created by Niek van de Pas on 19/03/2024.
//

import SwiftUI
import UserNotifications

final class AppDelegate: NSObject, NSApplicationDelegate, UNUserNotificationCenterDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        if let window = NSApplication.shared.windows.first {
            window.collectionBehavior = .fullScreenNone
        }

        UNUserNotificationCenter.current().delegate = self

        ensureMainWindowIsOpen()
    }

    func applicationDidBecomeActive(_ notification: Notification) {
        ensureMainWindowIsOpen()
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if response.actionIdentifier == "START_NEXT_TIMER" {
            // Handle the action here
            // For example, you can start the next timer
            // Call the appropriate method on your view model
            TimerViewModel.shared.startTimer()
        }
        completionHandler()
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
