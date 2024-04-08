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
        let picker = Picker("Number of sessions", selection: $settingsManager.sessionGoal) {
            Text("2").tag(2)
            Text("3").tag(3)
            Text("4").tag(4)
            Text("5").tag(5)
            Text("6").tag(6)
        }

        Form {
            VStack(alignment: .leading) {
                KeyboardShortcuts.Recorder("Global shortcut", name: .toggleTimer)
                Toggle("Shortcut brings app to front", isOn: $settingsManager.globalShortcutBringsAppToFront)
                    .toggleStyle(.checkbox)

                Divider()

                Toggle("Hide app when timer starts", isOn: $settingsManager.hideAppOnTimerStart)
                    .toggleStyle(.checkbox)
                Toggle("Show time left", isOn: $settingsManager.showTimeLeft)
                    .toggleStyle(.checkbox)
                if #available(macOS 14.0, *) {
                    picker.pickerStyle(.palette)
                } else {
                    picker
                }
            }
        }
        .formStyle(.grouped)
    }
}
