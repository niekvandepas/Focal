//
//  TimerDurationInput.swift
//  Focal
//
//  Created by Niek van de Pas on 02/01/2025.
//

import SwiftUI

struct TimerDurationInput: View {
    var label: String
    @Binding var duration: Int // Duration in seconds
    @State private var displayedDuration: Int // Duration in minutes for display

    init(label: String, duration: Binding<Int>) {
        self.label = label
        _duration = duration
        _displayedDuration = State(initialValue: duration.wrappedValue / 60) // Convert seconds to minutes for display
    }

    var body: some View {
        HStack {
            Text(label)
                .frame(width: 75, alignment: .leading)
            TextField("Enter long break duration", value: $displayedDuration, formatter: NumberFormatter(), onEditingChanged: { isCurrentlyEditing in
                guard !isCurrentlyEditing else {
//                    TODO remove prints
                    print("Returning early since we're currently editing")
                    return
                }
                print("Is finished editing")
                let oldDuration = duration
                duration = displayedDuration * 60

                // Ensure the value is within the allowed range (5 minutes to 120 minutes)
                if duration < 5 * 60 {
                    duration = 5 * 60
                } else if duration > 120 * 60 {
                    duration = 120 * 60
                }

                // Assume that when the timer full and the user changes the value, the duration of the timer should be reset to the new value. Conversely, when the timer has already decreased, leave the time remaining intact so as to not interfere with ongoing sessions.
                print(isCurrentlyEditing)
//                print("displayedDuration: \(displayedDuration)")
//                print("timeRemaining: \(TimerViewModel.shared.timeRemaining)")
//                print("oldDuration: \(oldDuration)")
//                print("duration: \(duration)")
                let isChangingDurationForCurrentlyActiveTimer = _
                if TimerViewModel.shared.timeRemaining >= oldDuration && isChangingDurationForCurrentlyActiveTimer {
//                    TODO remove prints
                    print("timer is full")
//                    TODO this is a problem. First check if the current timer state is what we're currently editing.
                    TimerViewModel.shared.timeRemaining = duration
                }
                print()
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
    TimerDurationInput(label: "Short break:", duration: .constant(120))
        .padding()
        .frame(width: 420)
}
