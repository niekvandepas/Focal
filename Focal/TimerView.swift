//
//  ContentView.swift
//  Focal
//
//  Created by Niek van de Pas on 11/03/2024.
//

import SwiftUI
import HotKey

struct TimerView: View {
    @StateObject var viewModel: TimerViewModel
    private let hotkey = HotKey(key: .f, modifiers: [.command, .control, .shift])

    var body: some View {
        VStack {
            Text("\(viewModel.timeRemaining / 60):\(viewModel.timeRemaining % 60, specifier: "%02d")")
                .font(.custom("SF Mono", size: 50))
                .fontWeight(.bold)
                .padding()
            
            HStack {
                Button(action: {
                    viewModel.toggleTimer()
                }) {
                    Text(viewModel.timerIsRunning ? "Pause" : "Start")
                }
                .padding()
                .disabled(viewModel.timeRemaining == 0)
                .keyboardShortcut(" ")

                Button(action: {
                    viewModel.resetTimer()
                }) {
                    Text("Reset")
                }
                .padding()
                .keyboardShortcut(KeyEquivalent("r"), modifiers: [.command])
            }
        }
        .onAppear {
            hotkey.keyDownHandler = {
                viewModel.toggleTimer()
                NSApp.activate()
            }
        }
    }
}

//#Preview {
//    ContentView()
//}
