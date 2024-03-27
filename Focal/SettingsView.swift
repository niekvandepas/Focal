//
//  SettingsView.swift
//  Focal
//
//  Created by Niek van de Pas on 20/03/2024.
//

import SwiftUI
import KeyboardShortcuts

struct SettingsView: View {
    @ObservedObject var settingsManager: SettingsManager

    var body: some View {
        Form {
            VStack(alignment: .leading) {
                KeyboardShortcuts.Recorder("Global shortcut", name: .toggleTimer)
                Toggle("Brings app to front", isOn: $settingsManager.globalShortcutBringsAppToFront)
                .toggleStyle(.checkbox)

                Divider()

                Toggle("Hide app when timer starts", isOn: $settingsManager.hideAppOnTimerStart)
                    .toggleStyle(.checkbox)
                Toggle("Show time left", isOn: $settingsManager.showTimeLeft)
                    .toggleStyle(.checkbox)
            }
        }
        .formStyle(.grouped)
    }
}
