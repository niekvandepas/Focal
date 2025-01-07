//
//  TimerDurationStepper.swift
//  Focal
//
//  Created by Niek van de Pas on 05/01/2025.
//

import SwiftUI

struct TimerDurationStepper: View {
    let settingsManager = SettingsManager.shared
    var timerState: TimerState
    @Binding var duration: Int // Duration in seconds
    @State var oldDuration: Int

    init(forTimerState timerState: TimerState, duration: Binding<Int>) {
        self.timerState = timerState
        self._duration = duration
        self.oldDuration = duration.wrappedValue
    }

    func incrementStep() {
        let maxDuration = getMaxDuration()
        if duration + 60 <= maxDuration {
            duration += 60
        }
    }

    func decrementStep() {
        let minDuration = getMinDuration()
        if duration - 60 >= minDuration {
            duration -= 60
        }
    }

    func getMinDuration() -> Int {
        switch timerState {
        case .work:
            return Constants.MIN_WORK_DURATION
        case .rest:
            return Constants.MIN_REST_DURATION
        case .longRest:
            return Constants.MIN_LONG_REST_DURATION
        }
    }

    func getMaxDuration() -> Int {
        switch timerState {
        case .work:
            return Constants.MAX_WORK_DURATION
        case .rest:
            return Constants.MAX_REST_DURATION
        case .longRest:
            return Constants.MAX_LONG_REST_DURATION
        }
    }

    /// Updates the remaining time of the active timer if the duration is changed while the timer is full.
    func maybeUpdateTimeRemaining() {
        // Assume that when the timer full and the user changes the value,
        // the duration of the timer should be changed to the new value.
        // Conversely, when the timer has already decreased,
        // leave the time remaining intact so as to not interfere with ongoing sessions.
        let isChangingDurationForCurrentlyActiveTimer = self.timerState == TimerViewModel.shared.timerState
        let timerIsFull = TimerViewModel.shared.timeRemaining == oldDuration
        let durationIsLessThanTimeRemainingInTimer = duration < TimerViewModel.shared.timeRemaining

        if isChangingDurationForCurrentlyActiveTimer && (timerIsFull || durationIsLessThanTimeRemainingInTimer) {
            TimerViewModel.shared.timeRemaining = duration
        }
        oldDuration = duration
    }

    var body: some View {
        let label = switch timerState {
        case .work:
            "Work:"
        case .rest:
            "Short break:"
        case .longRest:
            "Long break:"
        }

        Stepper {
            HStack {
                Text(label)
//                On macOS, the text should be pushed to the right, towards the stepper, to have them aligned.
                //  On iOS, this isn't possible anyway, and having them left-aligned looks neater.
//                #if os(macOS)
                Spacer()
//                #endif
                Text("\(duration / 60) minutes")
            }
        }
        onIncrement: {
            incrementStep()
            maybeUpdateTimeRemaining()
        }
        onDecrement: {
            decrementStep()
            maybeUpdateTimeRemaining()
        }
        #if os(macOS)
        .frame(width: 170)
        #endif
    }
}
