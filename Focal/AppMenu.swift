//
//  AppMenu.swift
//  Focal
//
//  Created by Niek van de Pas on 12/03/2024.
//

import SwiftUI

struct AppMenu: View {
    @StateObject var timerViewModel = TimerViewModel.shared
    
    func handleStartOrPause() {
        if timerViewModel.timerIsRunning {
            timerViewModel.pauseTimer()
        }
        else {
            timerViewModel.startTimer()
        }
    }

    func bringAppToFront() {
        if #available(macOS 14.0, *) {
            NSApp.activate()
        }
        else {
            NSApplication.shared.activate(ignoringOtherApps: true)
        }
    }

    func quitApp() {
        NSApplication.shared.terminate(nil)
    }

    func showSettings() {
        NSApp.sendAction(Selector(("showSettingsWindow:")), to: nil, from: nil)
    }

    var body: some View {
        Button(action: handleStartOrPause, label: { timerViewModel.timerIsRunning ? Text("Pause Timer") : Text("Start Timer") })
            .keyboardShortcut(" ", modifiers: [])

        Button(action: timerViewModel.resetTimer, label: { Text("Reset Timer") })
            .disabled(timerViewModel.timerIsFull && timerViewModel.timerState == .work && !timerViewModel.timerIsRunning )
            .keyboardShortcut(KeyEquivalent("r"), modifiers: [.command])

        Divider()

        Button(action: bringAppToFront, label: { Text("Open Focal") })
            .keyboardShortcut(KeyEquivalent("o"), modifiers: [.command])

        if #available(macOS 14.0, *) {
            SettingsLink()
                .keyboardShortcut(KeyEquivalent(","), modifiers: [.command])
        }
        else {
            Button(action: showSettings, label: { Text("Settings...") })
                .keyboardShortcut(KeyEquivalent(","), modifiers: [.command])
        }

        Button(action: quitApp, label: { Text("Quit Focal") })
            .keyboardShortcut(KeyEquivalent("q"), modifiers: [.command])
    }
}
