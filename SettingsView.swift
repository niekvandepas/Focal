//
//  SettingsView.swift
//  Focal
//
//  Created by Niek van de Pas on 20/03/2024.
//

import SwiftUI

#if os(macOS)
import KeyboardShortcuts

struct SettingsView: View {
    @EnvironmentObject var settingsViewModel: SettingsViewModel

    var body: some View {
        Form {
            VStack {
                Toggle("Hide time left", isOn: $settingsViewModel.hideTime)
                    .toggleStyle(.checkbox)
                    .padding()
                KeyboardShortcuts.Recorder("Toggle timer shortcut:", name: .toggleTimer)
                Toggle("Toggle timer shortcut brings app to front ", isOn: $settingsViewModel.globalShortcutBringsAppToFront)
                    .toggleStyle(.checkbox)
                    .padding()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
        }
        .formStyle(.grouped)
    }
}
#endif

class SettingsViewModel: ObservableObject {
    @AppStorage("hideTime") var hideTime = false
    @AppStorage("globalShortcutBringsAppToFront") var globalShortcutBringsAppToFront = false
}
