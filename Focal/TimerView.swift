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
            timerRect
            buttons
        }
//        .background(.yellow)
    }

    var timerRect: some View {
        ZStack {
            Rectangle()
                .fill(self.viewModel.timerState == .work ? .workBlue : .breakGreen)
                .frame(width: 200, height: 200)
                .multilineTextAlignment(.center)
                .cornerRadius(8)
                .shadow(radius: 1, x: 5, y: 5)
                .padding(.bottom, 10)

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
    }

    var buttons: some View {
        let cornerRadius: CGFloat = 0

        return HStack {
            Button(action: {
                viewModel.toggleTimer()
            }) {
                Text(viewModel.timerIsRunning ? "Pause" : "Start")
                    .padding(.vertical, 10)
                    .padding(.horizontal, 20)
                    .bold()
            }
            .disabled(viewModel.timeRemaining == 0)
            .keyboardShortcut(" ")
            .foregroundColor(.white)
            .background(.primaryButton)
            .cornerRadius(cornerRadius)
            .border(.black, width: 2)
            .background( // rounded border
                RoundedRectangle(cornerRadius: cornerRadius)
                    .offset(x: 3, y: 3)
            )

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
            .cornerRadius(cornerRadius)
            .border(.black, width: 2)
            .background( // rounded border
                RoundedRectangle(cornerRadius: cornerRadius)
                    .offset(x: 3, y: 3)
            )        }
//            .background(.green)
        .frame(width: 220)
    }
}

//#Preview {
//    ContentView()
//}
