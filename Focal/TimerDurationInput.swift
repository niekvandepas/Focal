//
//  TimerDurationInput.swift
//  Focal
//
//  Created by Niek van de Pas on 02/01/2025.
//

import SwiftUI

struct TimerDurationInput: View {
    var label: String
    var timerState: TimerState
    @Binding var duration: Int // Duration in seconds
    @State private var displayedDuration: Int // Duration in minutes for display

    init(label: String, duration: Binding<Int>, forTimerState timerState: TimerState) {
        self.label = label
        self.timerState = timerState
        _duration = duration
        _displayedDuration = State(initialValue: duration.wrappedValue / 60) // Convert seconds to minutes for display
    }

    var body: some View {
        HStack {
            Text(label)
                .frame(width: 75, alignment: .leading)
            TextField("Enter long break duration", value: $displayedDuration, formatter: NumberFormatter(), onEditingChanged: { isCurrentlyEditing in
                guard !isCurrentlyEditing else { return }
                let oldDuration = duration
                duration = displayedDuration * 60

//                TODO this doesn't work. (also update displayedDuration).
//                TODO this should be different for breaks. A 1 minute break is okay.
                if duration < 5 * 60 {
                    duration = 5 * 60
                    displayedDuration = duration / 60 // 5 minute minimum
                } else if duration > 120 * 60 {
                    duration = 120 * 60
                    displayedDuration = duration / 60 // 120 minute maximum
                }

                // Assume that when the timer full and the user changes the value, the duration of the timer should be reset to the new value. Conversely, when the timer has already decreased, leave the time remaining intact so as to not interfere with ongoing sessions.
                let isChangingDurationForCurrentlyActiveTimer = self.timerState == TimerViewModel.shared.timerState
                if TimerViewModel.shared.timeRemaining >= oldDuration && isChangingDurationForCurrentlyActiveTimer {
                    TimerViewModel.shared.timeRemaining = duration
                }
            })
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .frame(width: 44)

            Text("minutes")
        }
        .onAppear {
            // Convert seconds to minutes before displaying it
            duration = duration / 60
        }
    }
}

#Preview {
    TimerDurationInput(label: "Short break:", duration: .constant(120), forTimerState: .rest)
        .padding()
        .frame(width: 420)
}
