//
//  AppMenu.swift
//  Focal
//
//  Created by Niek van de Pas on 12/03/2024.
//

import SwiftUI

struct AppMenu: View {
    @StateObject var viewModel: TimerViewModel
    
    func handleStartOrPause() {
        if viewModel.timerIsRunning {
            viewModel.pauseTimer()
        }
        else {
            viewModel.startTimer()
        }
    }

    var body: some View {
        Button(action: handleStartOrPause, label: { viewModel.timerIsRunning ? Text("Pause") : Text("Start") })
            .keyboardShortcut(" ", modifiers: [])

        Divider()

        Button(action: viewModel.resetTimer, label: { Text("Reset") })
            .disabled(viewModel.timeRemaining == 25 * 60 && !viewModel.timerIsRunning )
            .keyboardShortcut(KeyEquivalent("r"), modifiers: [.command])
    }
}
