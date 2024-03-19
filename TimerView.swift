//
//  ContentView.swift
//  Focal
//
//  Created by Niek van de Pas on 11/03/2024.
//

import SwiftUI
#if os(macOS)
import HotKey
import AppKit
#endif

struct TimerView: View {
    @StateObject var viewModel: TimerViewModel
    #if os(macOS)
    private let hotkey = HotKey(key: .f, modifiers: [.command, .control, .shift])
    #endif


    var body: some View {
#if os(macOS)
        let buttonFrameWidth = 200.0
#else
        let buttonFrameWidth = 250.0
#endif

        VStack {
            timerRect
                .frame(width:200)
            buttons
                .frame(width:buttonFrameWidth)
        }
    }

    var timerRect: some View {
        // work:    .workBlue
        // rest:    .breakGreen
        // paused:  .offWhite
        let timerSquareColor: Color = viewModel.timerIsRunning ? (viewModel.timerState == .work ? Color.workBlue : Color.breakGreen) : Color.offWhite
#if os(macOS)
        let timerStateLabelFontSize = 18.0
#else
        let timerStateLabelFontSize = 26.0
#endif

#if os(macOS)
        let timerTimeLeftFontSize = 50.0
#else
        let timerTimeLeftFontSize = 64.0
#endif
#if os(macOS)
        let timerRectangleWidth = 200.0
#else
        let timerRectangleWidth = 250.0
#endif
#if os(macOS)
        let timerRectangleHeight = 200.0
#else
        let timerRectangleHeight = 250.0
#endif


        return ZStack {
            Rectangle()
                .fill(timerSquareColor)
                .frame(width: timerRectangleWidth, height: timerRectangleHeight)
                .multilineTextAlignment(.center)
                .cornerRadius(8)
                .shadow(radius: 1, x: 5, y: 5)
                .padding(.bottom, 10)

            VStack {
                Text(viewModel.timerState.description.capitalized)
                    .font(.custom("Inter", size: timerStateLabelFontSize))
                    .padding(.bottom, -20)
                    .foregroundStyle(.black)

                Text("\(viewModel.timeRemaining / 60):\(viewModel.timeRemaining % 60, specifier: "%02d")")
                    .font(.custom("Inter", size: timerTimeLeftFontSize))
                    .padding()
                    .foregroundStyle(.primaryButton)

            }
#if os(macOS)
            .onAppear {
                hotkey.keyDownHandler = {
                    viewModel.toggleTimer()
                }
            }
#endif
        }
    }

    var buttons: some View {

        let startPauseButton = Button(action: {
            viewModel.toggleTimer()
        }) {
            // Overlay the actual text on hidden "Pause" text to ensure the button is always the same width,
            // https://stackoverflow.com/questions/77051742/how-to-create-a-fixed-size-swiftui-button-when-label-content-changes
            Text("Pause")
                .hidden()
                .overlay(Text(viewModel.timerIsRunning ? "Pause" : "Start"))
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
        #if os(macOS)
        .focusEffectDisabled()
        #endif

    }
}

//#Preview {
//    ContentView()
//}
