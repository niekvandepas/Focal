//
//  EditableTimerLabel.swift
//  Focal
//
//  Created by Niek van de Pas on 22/12/2024.
//

import SwiftUI

enum EditableTimerLabelSizeVariant {
    case small
    case large
}

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

struct EditableTimerLabel: View {
    @Binding var timerLabel: String
    var variant: EditableTimerLabelSizeVariant
    @StateObject var timerViewModel = TimerViewModel.shared
    @State var lastUsedRestTimerName: String = TimerViewModel.shared.restTimerName
    @State var lastUsedWorkTimerName: String = TimerViewModel.shared.workTimerName
    @FocusState private var isTextFieldFocused: Bool  // Track focus state

    init(for text: Binding<String>, variant: EditableTimerLabelSizeVariant) {
        self._timerLabel = text  // This binds the internal 'text' to the external 'for'
        self.variant = variant
    }

    var body: some View {
    return TextField("", text: $timerLabel)
        .font(.custom("Inter", size: variant == .small ? timerStateLabelFontSize : timerTimeLeftFontSize))
        // For the large variant, push the label up by 20 points by setting negative padding
        .padding(variant == .small ? .bottom : [], variant == .small ? -20 : 0)
        .foregroundStyle(variant == .small ? .black : .primaryButton)
        .textFieldStyle(PlainTextFieldStyle())
        .multilineTextAlignment(.center)
        .focused($isTextFieldFocused)
        .onChange(of: isTextFieldFocused) { newValue in
            // When focus changes (user clicks out of the TextField)
            if !newValue { // This triggers when user clicks "out" of the TextField
                handleFocusLost()
            }
        }
        .onChange(of: timerLabel) { newValue in
            // Uppercase characters take up more horizontal space than lowercase characters.
            // To ensure the timer label does not overflow its container,
            // and yet allow the user as much leniency as possible,
            // we check to see if the entered label is all lowercase.
            let MAX_LABEL_LENGTH_WHEN_ALL_LOWERCASE = 6
            let MAX_LABEL_LENGTH_WHEN_NOT_ALL_LOWERCASE = 5
            let isAllLowercase = newValue.allSatisfy { $0.isLowercase }

            if isAllLowercase && newValue.count > MAX_LABEL_LENGTH_WHEN_ALL_LOWERCASE {
                if timerViewModel.timerState == .rest {
                    timerViewModel.restTimerName = String(newValue.prefix(MAX_LABEL_LENGTH_WHEN_ALL_LOWERCASE))
                }
                else {
                    timerViewModel.workTimerName = String(newValue.prefix(MAX_LABEL_LENGTH_WHEN_ALL_LOWERCASE))
                }
            }
            if (!isAllLowercase) && newValue.count > MAX_LABEL_LENGTH_WHEN_NOT_ALL_LOWERCASE {
                if timerViewModel.timerState == .rest {
                    timerViewModel.restTimerName = String(newValue.prefix(MAX_LABEL_LENGTH_WHEN_NOT_ALL_LOWERCASE))
                }
                else {
                    timerViewModel.workTimerName = String(newValue.prefix(MAX_LABEL_LENGTH_WHEN_NOT_ALL_LOWERCASE))
                }
            }

        }

        .onSubmit {
            // Disallow empty timer names by ignoring changes and reverting to the last timer name
            if timerLabel.isEmpty || timerLabel.allSatisfy({ $0.isWhitespace }) {
                switch timerViewModel.timerState {
                case .work:
                    timerViewModel.workTimerName = lastUsedWorkTimerName
                case .longRest:
                    fallthrough
                case .rest:
                    timerViewModel.restTimerName = lastUsedRestTimerName
                }
            }
            else {
                switch timerViewModel.timerState {
                case .work:
                    lastUsedWorkTimerName = timerLabel
                case .longRest:
                    fallthrough
                case .rest:
                    lastUsedRestTimerName = timerLabel
                }
            }
        }
    }

    /// Handles focus loss from the timer label text field. If the label is empty or contains only whitespace, it restores the last used timer name based on the current timer state. Otherwise, it updates the last used timer name with the new label.
    private func handleFocusLost() {
        if timerLabel.isEmpty || timerLabel.allSatisfy({ $0.isWhitespace }) {
            switch timerViewModel.timerState {
            case .work:
                timerViewModel.workTimerName = lastUsedWorkTimerName
            case .longRest:
                fallthrough
            case .rest:
                timerViewModel.restTimerName = lastUsedRestTimerName
            }
        } else {
            switch timerViewModel.timerState {
            case .work:
                lastUsedWorkTimerName = timerLabel
            case .longRest:
                fallthrough
            case .rest:
                lastUsedRestTimerName = timerLabel
            }
        }
    }

}
