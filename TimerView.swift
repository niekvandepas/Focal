//
//  ContentView.swift
//  Focal
//
//  Created by Niek van de Pas on 11/03/2024.
//

import SwiftUI
#if os(macOS)
import KeyboardShortcuts
import AppKit
#endif

struct TimerView: View {
    @StateObject var timerViewModel = TimerViewModel.shared
    @ObservedObject var settingsManager = SettingsManager.shared

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
        let timerSquareColor: Color = timerViewModel.timerIsRunning ? (timerViewModel.timerState == .work ? Color.workBlue : Color.breakGreen) : Color.offWhite
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

//        TODO fix this to check if the text is empty, which it is by default because of placeholder stuff
        let timerLabelText = {
            switch timerViewModel.timerState {
            case .work:
                settingsManager.optionalTimerWorkLabel == "" ? "Work" : settingsManager.optionalTimerWorkLabel
            case .rest:
                settingsManager.optionalTimerBreakLabel == "" ? "Break" : settingsManager.optionalTimerBreakLabel
            }

        }()

        let timerText = settingsManager.showTimeLeft ? timerViewModel.timeRemainingFormatted : timerLabelText

        return ZStack {
            Rectangle()
                .fill(timerSquareColor)
                .frame(width: timerRectangleWidth, height: timerRectangleHeight)
                .multilineTextAlignment(.center)
                .cornerRadius(8)
                .shadow(radius: 1, x: 5, y: 5)
                .padding(.bottom, 10)

            VStack {
                if settingsManager.showTimeLeft {
                    Text(timerLabelText)
                        .font(.custom("Inter", size: timerStateLabelFontSize))
                        .padding(.bottom, -20)
                        .foregroundStyle(.black)
                }

                Text(timerText)
                    .font(.custom("Inter", size: timerTimeLeftFontSize))
                    .padding()
                    .foregroundStyle(.primaryButton)

            }
        }
    }

    var buttons: some View {

        let notificationFeedbackGenerator = UINotificationFeedbackGenerator()
        let mediumFeedbackGenerator = UIImpactFeedbackGenerator(style: .medium)

        let startPauseButton = Button(action: {
            timerViewModel.timerIsRunning ? mediumFeedbackGenerator.impactOccurred() : notificationFeedbackGenerator.notificationOccurred(.success)

            // Immediately decreasing from 25:00 to 24:59 indicates visual responsiveness to the user
            timerViewModel.timeRemaining = min(1499, timerViewModel.timeRemaining)

            timerViewModel.toggleTimer()
#if os(macOS)
            if settingsManager.hideAppOnTimerStart && timerViewModel.timerIsRunning {
                NSApp.hide(self)
            }
#endif
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            timerViewModel.notificationScheduled = false
        }) {
            // Overlay the actual text on hidden "Pause" text to ensure the button is always the same width,
            // https://stackoverflow.com/questions/77051742/how-to-create-a-fixed-size-swiftui-button-when-label-content-changes
            Text("Pause")
                .hidden()
                .overlay(Text(timerViewModel.timerIsRunning ? "Pause" : "Start"))
                .padding(.vertical, 10)
                .padding(.horizontal, 20)
                .bold()
        }
        .customFocus()
        .disabled(timerViewModel.timeRemaining == 0)
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
            timerViewModel.resetTimer()
        }) {
            Text("Reset")
                .padding(.vertical, 10)
                .padding(.horizontal, 20)
                .foregroundStyle(.primaryButton)
        }
        .disabled(timerViewModel.timerIsFull)
        .customFocus()
        .keyboardShortcut(KeyEquivalent("r"), modifiers: [.command])
        .background(.white)
        .border(.black, width: 2)
        .background( // rounded border
            RoundedRectangle(cornerRadius: 0)
                .offset(x: 3, y: 3)
                .fill(.black)
        )
        .overlay(timerViewModel.timerIsFull ? GeometryReader { geometry in
            // Draw a red X
            Path { path in
                path.move(to: CGPoint(x: 0, y: 0))
                path.addLine(to: CGPoint(x: geometry.size.width, y: geometry.size.height))
                path.move(to: CGPoint(x: geometry.size.width, y: 0))
                path.addLine(to: CGPoint(x: 0, y: geometry.size.height))
            }
            .stroke(Color.red, lineWidth: 5)
        } : nil)

        if #available(macOS 14.0, *) {
            return HStack {
                startPauseButton
                Spacer()
                resetButton
            }
            .buttonStyle(MyButtonStyle())
#if os(macOS)
            .focusEffectDisabled()
#endif
        } else {
            return HStack {
                startPauseButton
                Spacer()
                resetButton
            }
            .buttonStyle(MyButtonStyle())
        }

    }
}

//#Preview {
//    ContentView()
//}
