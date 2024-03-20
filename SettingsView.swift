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
                Toggle("Hide Time", isOn: $settingsViewModel.hideTime)
                    .padding()
                KeyboardShortcuts.Recorder("Toggle Timer Shortcut:", name: .toggleTimer)
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
}
