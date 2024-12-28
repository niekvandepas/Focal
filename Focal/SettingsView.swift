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

            // ---Global Keyboard Shortcut---
            KeyboardShortcuts.Recorder("Global keyboard shortcut:", name: .toggleTimer)

            Text(
                """
                Start and stop the timer from anywhere in macOS.
                """
            )
            .font(.callout)
            .foregroundStyle(.gray)
            .padding(.bottom, 4)


            Toggle("Global shortcut brings app to front", isOn: $settingsManager.globalShortcutBringsAppToFront)
                .toggleStyle(.checkbox)

            Divider()
                .padding(8)

            // ---Application Behavior---

            Toggle("Show menu bar icon", isOn: $settingsManager.showMenuBarIcon)
                .toggleStyle(.checkbox)

            Toggle("Show time left in menu bar", isOn: $settingsManager.showTimeLeftInMenuBar)
                .toggleStyle(.checkbox)

            Toggle("Show time left in timer", isOn: $settingsManager.showTimeLeft)
                .toggleStyle(.checkbox)

            Toggle("Start next timer automatically", isOn: $settingsManager.startNextTimerAutomatically)
                .toggleStyle(.checkbox)

            Toggle("Hide Focal when timer starts", isOn: $settingsManager.hideAppOnTimerStart)
                .toggleStyle(.checkbox)

            Toggle("Bring Focal to front when timer ends", isOn: $settingsManager.showAppOnTimerElapse)
                .toggleStyle(.checkbox)

            if #available(macOS 14.0, *) {
                picker.pickerStyle(.palette)
            } else {
                picker
            }

            Divider()
                .padding(8)

            // ---Notification Settings---

            Toggle("Show notifications", isOn: $settingsManager.notificationsAreOn)
                .toggleStyle(.checkbox)

            HStack {
                Toggle("Play sound for notifications", isOn: $settingsManager.notificationSoundIsOn)
                    .toggleStyle(.checkbox)
                    .disabled(!settingsManager.notificationsAreOn)

                GridRow {
                    Picker("Notification sound:", selection: $settingsManager.notificationSound) {
                        Text("Arp").tag(1)
                        Text("Bell").tag(0) // 'Bell' is the default
                        Text("Buzz").tag(2)
                        Text("Fourths").tag(3)
                        Text("Home").tag(4)
                        Text("Suspended").tag(5)
                    }
                    .labelsHidden()
                    .disabled(!settingsManager.notificationsAreOn || !settingsManager.notificationSoundIsOn)
                    .onChange(of: settingsManager.notificationSound) { newValue in
                        if let nextSound = NotificationSound(rawValue: newValue) {
                            playSound(for: nextSound)
                            NotificationManager.updateNotificationSound(to: nextSound)
                        }
                    }
                }
            }

            Divider()
                .padding(8)

            // ---Keyboard Shortcuts---

            VStack(alignment: .leading) {
                Text("Keyboard Shortcuts")
                    .font(.headline)
                    .foregroundStyle(.primary)

                Text("""
                    ⌘ + R: Reset the timer
                    Space: Pause/start the timer
                    """)
                    .font(.callout)
                    .foregroundStyle(.gray)
            }
            .padding(.bottom, 4)
            .frame(maxWidth: .infinity, alignment: .leading) // Ensures text is not truncated
            .fixedSize(horizontal: false, vertical: true) // Prevents truncation by allowing multiline content
        }
        .padding()

    }

    private func playSound(for notificationSound: NotificationSound) {
        NSSound(named: notificationSound.fileName)?.play()
    }

}

#Preview {
    return SettingsView(settingsManager: SettingsManager.shared)
        .frame(width: 420)
}
