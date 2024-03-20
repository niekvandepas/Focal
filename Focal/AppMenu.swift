//
//  AppMenu.swift
//  Focal
//
//  Created by Niek van de Pas on 12/03/2024.
//

import SwiftUI

struct AppMenu: View {
    @StateObject var viewModel = TimerViewModel.shared
    
    func handleStartOrPause() {
        if viewModel.timerIsRunning {
            viewModel.pauseTimer()
        }
        else {
            viewModel.startTimer()
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

    var body: some View {
        Button(action: handleStartOrPause, label: { viewModel.timerIsRunning ? Text("Pause Timer") : Text("Start Timer") })
            .keyboardShortcut(" ", modifiers: [])

        Divider()

        Button(action: viewModel.resetTimer, label: { Text("Reset Timer") })
            .disabled(viewModel.timeRemaining == 25 * 60 && !viewModel.timerIsRunning )
            .keyboardShortcut(KeyEquivalent("r"), modifiers: [.command])

        Divider()

        Button(action: bringAppToFront, label: { Text("Open Focal") })
            .keyboardShortcut(KeyEquivalent("o"), modifiers: [.command])

        Button(action: quitApp, label: { Text("Quit Focal") })
            .keyboardShortcut(KeyEquivalent("q"), modifiers: [.command])
    }
}
