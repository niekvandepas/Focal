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
        }
    }
}
