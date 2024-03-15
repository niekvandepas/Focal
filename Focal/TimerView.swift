//
//  ContentView.swift
//  Focal
//
//  Created by Niek van de Pas on 11/03/2024.
//

import SwiftUI
import HotKey
import AppKit

struct TimerView: View {
    @StateObject var viewModel: TimerViewModel
    private let hotkey = HotKey(key: .f, modifiers: [.command, .control, .shift])

    var body: some View {
        VStack {
            ZStack {
                Rectangle()
                    .fill(Color.blue)
                    .frame(width: 200, height: 200)
                    .multilineTextAlignment(.center)
                    .cornerRadius(8)

                VStack {
                    Text(viewModel.timerState.description.capitalized)
                        .font(.custom("Inter", size: 18))
                        .padding(.bottom, -20)

                    Text("\(viewModel.timeRemaining / 60):\(viewModel.timeRemaining % 60, specifier: "%02d")")
                        .font(.custom("Inter", size: 50))
                        .padding()
                        .foregroundStyle(.primaryButton)

                }
                .onAppear {
                    hotkey.keyDownHandler = {
                        viewModel.toggleTimer()
                        NSApp.activate()
                    }
                }
            }

            HStack {
                Button(action: {
                    viewModel.toggleTimer()
                }) {
                    Text(viewModel.timerIsRunning ? "Pause" : "Start")
                        .padding(.vertical, 10)
                        .padding(.horizontal, 20)
                }
                .disabled(viewModel.timeRemaining == 0)
                .keyboardShortcut(" ")
                .font(.headline)
                .foregroundColor(.white)
                .background(.primaryButton)
                .cornerRadius(2)

                Button(action: {
                    viewModel.resetTimer()
                }) {
                    Text("Reset")
                        .padding(.vertical, 10)
                        .padding(.horizontal, 20)
                        .foregroundStyle(.primaryButton)
                }
                .keyboardShortcut(KeyEquivalent("r"), modifiers: [.command])
                .font(.headline)
                .background(.white)
                .cornerRadius(2)
            }
//            .background(.green)
            .frame(width: 220)
        }
//        .background(.yellow)
    }
}

//#Preview {
//    ContentView()
//}
