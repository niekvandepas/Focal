//
//  SettingsIcon.swift
//  Focal iOS
//
//  Created by Niek van de Pas on 21/03/2024.
//

import SwiftUI

struct SettingsIcon: View {
    let timerViewModel = TimerViewModel.shared
    let settingsManager = SettingsManager.shared

    var body: some View {
        HStack {
            Spacer()
            NavigationLink(destination: SettingsView(settingsManager: settingsManager)) {
                Image(systemName: "gear")
                    .font(.title)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 16)
                    .foregroundStyle(.primaryButton)
            }

        }
    }
}
