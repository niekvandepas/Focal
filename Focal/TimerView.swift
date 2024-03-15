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
            Pill(timerState: self.viewModel.timerState)

            Text("\(viewModel.timeRemaining / 60):\(viewModel.timeRemaining % 60, specifier: "%02d")")
                .font(.custom("SF Mono", size: 50))
                .fontWeight(.bold)
                .padding()
            
            HStack {
                Spacer()

                Button(action: {
                    viewModel.toggleTimer()
                }) {
                    Text(viewModel.timerIsRunning ? "Pause" : "Start")
                }
                .disabled(viewModel.timeRemaining == 0)
                .keyboardShortcut(" ")
                .font(.headline)
                .foregroundColor(.white)
                .background(.blue)
                .cornerRadius(10)

                Spacer()

                Button(action: {
                    viewModel.resetTimer()
                }) {
                    Text("Reset")
                }
                .keyboardShortcut(KeyEquivalent("r"), modifiers: [.command])
                .font(.headline)
                .foregroundColor(.white)
                .background(.yellow)
                .cornerRadius(10)
                
                Spacer()
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
