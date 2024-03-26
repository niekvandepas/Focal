//
//  SettingsView.swift
//  Focal
//
//  Created by Niek van de Pas on 20/03/2024.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var settingsViewModel: SettingsViewModel

    var body: some View {
        Form {
            Toggle("Hide time left in timer", isOn: $settingsViewModel.hideTime)
            TextField("Custom Work Label", text: settingsViewModel.$optionalTimerWorkLabel)
            TextField("Custom Break Label", text: settingsViewModel.$optionalTimerBreakLabel)
        }
    }
}
