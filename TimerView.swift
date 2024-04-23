//
//  ContentView.swift
//  Focal
//
//  Created by Niek van de Pas on 11/03/2024.
//

import SwiftUI
import ConfettiSwiftUI
#if os(macOS)
import KeyboardShortcuts
import AppKit
#endif
import UserNotifications


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
            Spacer()
            Spacer()
            Spacer()
            timerRect
                .frame(width:200)
            buttons
                .frame(width:buttonFrameWidth)
            Spacer()
            Button("🎉") {
//                TODO
                timerViewModel.showConfettiTemp()
                    }
            Spacer()
            SkipButton(shown: timerViewModel.timerState == .rest, skipTimer: timerViewModel.skipTimer)
            Spacer()
                SessionMarkers(goal: settingsManager.sessionGoal, completedSessions: timerViewModel.completedSessions, timerState: timerViewModel.timerState, isRunning: timerViewModel.timerIsRunning)
                    .padding(.bottom)
            }
        .confettiCannon(counter: $timerViewModel.confettiCounter, num: 30, rainHeight: 400, repetitions: 2, repetitionInterval: 0.4)
    }

    var timerRect: some View {
        // work:    .workBlue
        // rest:    .breakGreen
        // paused:  .offWhite
        let timerSquareColor: Color = timerViewModel.timerIsRunning ? (timerViewModel.timerState == .work ? Color.workBlue : Color.breakGreen) : Color.offWhite
#if os(macOS)
        let timerStateLabelFontSize = 20.0
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

        let timerLabelText = {
            switch timerViewModel.timerState {
            case .work:
                settingsManager.optionalTimerWorkLabel == "" ? "Work" : settingsManager.optionalTimerWorkLabel
            case .rest:
                settingsManager.optionalTimerBreakLabel == "" ? "Rest" : settingsManager.optionalTimerBreakLabel
            }
        }()

        let timerText = settingsManager.showTimeLeft ? timerViewModel.timeRemainingFormatted : timerLabelText

        return ZStack {
            Rectangle()
                .fill(timerSquareColor)
                .frame(width: timerRectangleWidth, height: timerRectangleHeight)
                .multilineTextAlignment(.center)
                .cornerRadius(8)
                .shadow(color: .black, radius: 0, x: 5, y: 5)
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
#if os(iOS)
        let notificationFeedbackGenerator = UINotificationFeedbackGenerator()
        let mediumFeedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
#endif

        let startPauseButton = Button(action: {
#if os(iOS)
            timerViewModel.timerIsRunning ? mediumFeedbackGenerator.impactOccurred() : notificationFeedbackGenerator.notificationOccurred(.success)
#endif
            // Immediately decreasing from 25:00 to 24:59 indicates visual responsiveness to the user
            if timerViewModel.timerIsFull {
                timerViewModel.timeRemaining = 24 * 60 + 59
            }

            timerViewModel.timerIsRunning.toggle()
#if os(macOS)
            if settingsManager.hideAppOnTimerStart && timerViewModel.timerIsRunning {
                NSApp.hide(self)
            }
#endif
        }) {
            // Overlay the actual text on hidden "Pause" text to ensure the button is always the same width,
            // https://stackoverflow.com/questions/77051742/how-to-create-a-fixed-size-swiftui-button-when-label-content-changes
            Text("Pause")
                .hidden()
                .overlay(Text(timerViewModel.timerIsRunning ? "Pause" : "Start"))
                .padding(.vertical, 10)
                .padding(.horizontal, 20)
                .bold()
                .contentShape(Rectangle()) // This is needed to have the entire button actuate
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
                .contentShape(Rectangle()) // This is needed to have the entire button actuate
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

#Preview {
    return ZStack {
        Color.appRed
        TimerView(settingsManager: SettingsManager.shared)
           .frame(width: 300, height: 400)
    }
    .frame(width: 300, height: 400)
}
