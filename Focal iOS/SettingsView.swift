//
//  SettingsView.swift
//  Focal
//
//  Created by Niek van de Pas on 20/03/2024.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var settingsManager: SettingsManager

    var body: some View {
        Form {
            Toggle("Show time left", isOn: $settingsManager.showTimeLeft)
            TextField("Custom Work Label", text: settingsManager.$optionalTimerWorkLabel)
            TextField("Custom Break Label", text: settingsManager.$optionalTimerBreakLabel)
            Stepper {
                Text("Number of sessions: \(settingsManager.sessionGoal)")
            } onIncrement: {
                settingsManager.sessionGoal += 1
            } onDecrement: {
                settingsManager.sessionGoal -= 1
            }

            Picker("Notification sound:", selection: $settingsManager.notificationSound) {
                Text("Arp").tag(1)
                Text("Bell").tag(0) // 'Bell' is the default
                Text("Buzz").tag(2)
                Text("Fourths").tag(3)
                Text("Home").tag(4)
                Text("Suspended").tag(5)
            }
        }
    }
}

#Preview {
    return SettingsView(settingsManager: SettingsManager.shared)
}
