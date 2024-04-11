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
        let picker = Picker("Number of sessions:", selection: $settingsManager.sessionGoal) {
            Text("2").tag(2)
            Text("3").tag(3)
            Text("4").tag(4)
            Text("5").tag(5)
            Text("6").tag(6)
        }

        Grid(alignment: .leadingFirstTextBaseline) {
            KeyboardShortcuts.Recorder("Global keyboard shortcut:", name: .toggleTimer)

            Text(
                """
                The global keyboard shortcut starts or stops the timer from any app.
                """
            )
            .font(.callout)
            .foregroundStyle(.gray)
            .padding(.bottom, 4)


            Toggle("Shortcut brings app to front", isOn: $settingsManager.globalShortcutBringsAppToFront)
                .toggleStyle(.checkbox)

            Divider()
                .padding(8)

            Toggle("Show time left in timer", isOn: $settingsManager.showTimeLeft)
                .toggleStyle(.checkbox)
            Toggle("Hide app on timer start", isOn: $settingsManager.hideAppOnTimerStart)
                .toggleStyle(.checkbox)
            if #available(macOS 14.0, *) {
                picker.pickerStyle(.palette)
            } else {
                picker
            }

            Divider()
                .padding(8)

            GridRow {
                Text("Work timer name:")
                TextField("Work timer label", text: settingsManager.$optionalTimerWorkLabel, prompt: Text("Work"))
                    .background(.white)
                Spacer().frame(width:125, height: 0).hidden()
            }
            GridRow {
                Text("Rest timer name:")
                TextField("Rest timer name", text: settingsManager.$optionalTimerBreakLabel, prompt: Text("Rest"))
            }
        }
        .padding()

    }
}

#Preview {
    return SettingsView(settingsManager: SettingsManager.shared)
        .frame(width: 420)
}
