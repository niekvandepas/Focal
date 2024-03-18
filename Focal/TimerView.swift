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
                .frame(width:200)
            buttons
                .frame(width:200)
        }
//        .background(.yellow)
    }

    var timerRect: some View {
        // work:    .workBlue
        // rest:    .breakGreen
        // paused:  .offWhite
        let timerSquareColor: Color = viewModel.timerIsRunning ? (viewModel.timerState == .work ? Color.workBlue : Color.breakGreen) : Color.offWhite

        return ZStack {
            Rectangle()
                .fill(timerSquareColor)
                .frame(width: 200, height: 200)
                .multilineTextAlignment(.center)
                .cornerRadius(8)
                .shadow(radius: 1, x: 5, y: 5)
                .padding(.bottom, 10)

            VStack {
                Text(viewModel.timerState.description.capitalized)
                    .font(.custom("Inter", size: 18))
                    .padding(.bottom, -20)
                    .foregroundStyle(.black)

                Text("\(viewModel.timeRemaining / 60):\(viewModel.timeRemaining % 60, specifier: "%02d")")
                    .font(.custom("Inter", size: 50))
                    .padding()
                    .foregroundStyle(.primaryButton)

            }
            .onAppear {
                hotkey.keyDownHandler = {
                    viewModel.toggleTimer()
                }
            }
        }
    }

//    TODO animate selected button 'floating' (hovering / moving slightly)?
    var buttons: some View {

        let startPauseButton = Button(action: {
            viewModel.toggleTimer()
        }) {
            Text(viewModel.timerIsRunning ? "Pause" : "Start")
                .padding(.vertical, 10)
                .padding(.horizontal, 20)
                .bold()
        }
        .customFocus()
        .disabled(viewModel.timeRemaining == 0)
        .keyboardShortcut(" ")
        .foregroundColor(.white)
        .background(.primaryButton)
        .border(.black, width: 2)
        .background( // rounded border
            RoundedRectangle(cornerRadius: 0)
                .offset(x: 3, y: 3)
                .fill(.black)
        )

        let resetButton = Button(action: {
            viewModel.resetTimer()
        }) {
            Text("Reset")
                .padding(.vertical, 10)
                .padding(.horizontal, 20)
                .foregroundStyle(.primaryButton)
        }
        .disabled(viewModel.timerIsFull)
        .customFocus()
        .keyboardShortcut(KeyEquivalent("r"), modifiers: [.command])
        .background(.white)
        .border(.black, width: 2)
        .background( // rounded border
            RoundedRectangle(cornerRadius: 0)
                .offset(x: 3, y: 3)
                .fill(.black)
        )
        .overlay(viewModel.timerIsFull ? GeometryReader { geometry in
            // Draw a red X
            Path { path in
                path.move(to: CGPoint(x: 0, y: 0))
                path.addLine(to: CGPoint(x: geometry.size.width, y: geometry.size.height))
                path.move(to: CGPoint(x: geometry.size.width, y: 0))
                path.addLine(to: CGPoint(x: 0, y: geometry.size.height))
            }
            .stroke(Color.red, lineWidth: 5)
        } : nil)

        return HStack {
            startPauseButton
            Spacer()
            resetButton
        }
        .buttonStyle(MyButtonStyle())
        .focusEffectDisabled()

//            .background(.green)
//        .frame(width: 220)
    }
}

//#Preview {
//    ContentView()
//}
