//
//  SettingsView.swift
//  Focal
//
//  Created by Niek van de Pas on 20/03/2024.
//

import SwiftUI
import KeyboardShortcuts

struct SettingsView: View {
    @EnvironmentObject var settingsViewModel: SettingsViewModel

    var body: some View {
        Form {
            VStack(alignment: .leading) {
                KeyboardShortcuts.Recorder("Global shortcut", name: .toggleTimer)
                Toggle("Brings app to front", isOn: $settingsViewModel.globalShortcutBringsAppToFront)
                .toggleStyle(.checkbox)

                Divider()

                Toggle("Hide app on timer start", isOn: $settingsViewModel.hideAppOnTimerStart)
                    .toggleStyle(.checkbox)
                Toggle("Hide timer duration", isOn: $settingsViewModel.hideTime)
                    .toggleStyle(.checkbox)
            }
        }
        .formStyle(.grouped)
    }
}
