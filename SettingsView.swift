//
//  SettingsView.swift
//  Focal
//
//  Created by Niek van de Pas on 20/03/2024.
//

import SwiftUI

#if os(macOS)
import KeyboardShortcuts
#endif

struct SettingsView: View {
    let settingsViewModel = SettingsViewModel.shared

    var body: some View {
        Form {
            VStack(alignment: .leading) {
#if os(macOS)
                Group {
                    KeyboardShortcuts.Recorder("Global shortcut", name: .toggleTimer)
                    Toggle("Bring app to front", isOn: settingsViewModel.$globalShortcutBringsAppToFront)
                        .toggleStyle(.checkbox)
                    Toggle("Hide app on timer start", isOn: settingsViewModel.$hideAppOnTimerStart)
                        .toggleStyle(.checkbox)
                }
                Divider()
#endif
                Group {
                    Toggle("Hide time left in timer", isOn: settingsViewModel.$hideTime)
#if os(macOS)
                        .toggleStyle(.checkbox)
#endif
                }
            }
        }
        .formStyle(.grouped)
    }
}

class SettingsViewModel: ObservableObject {
    static let shared = SettingsViewModel()
    private init() {}

    @AppStorage("hideTime") var hideTime = false
    @AppStorage("globalShortcutBringsAppToFront") var globalShortcutBringsAppToFront = false
    @AppStorage("hideAppOnTimerStart") var hideAppOnTimerStart = false
    @AppStorage("startNextTimerAutomatically") var startNextTimerAutomatically = false
}

