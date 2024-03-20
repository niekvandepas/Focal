//
//  SettingsView.swift
//  Focal
//
//  Created by Niek van de Pas on 20/03/2024.
//

import Foundation
import SwiftUI

class SettingsViewModel: ObservableObject {
    @AppStorage("hideTime") var hideTime = false
}

struct SettingsView: View {
    @EnvironmentObject var settingsViewModel: SettingsViewModel

    var body: some View {
        Form {
            VStack {
                Toggle("Hide Time", isOn: $settingsViewModel.hideTime)
                    .padding()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
        }
        .formStyle(.grouped)
    }
}
