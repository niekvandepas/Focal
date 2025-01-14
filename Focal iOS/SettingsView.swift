//
//  SettingsView.swift
//  Focal
//
//  Created by Niek van de Pas on 20/03/2024.
//

import AVFoundation
import SwiftUI

struct SettingsView: View {
    @ObservedObject var settingsManager: SettingsManager
    @State var audioPlayer: AVAudioPlayer?

    var body: some View {
        Form {
            Section {
                Toggle("Show time remaining", isOn: $settingsManager.showTimeLeft)

                Stepper {
                    HStack {
                        Text("Number of sessions:")
                        Spacer()
                        Text("\(settingsManager.sessionGoal)")
                    }
                } onIncrement: {
                    settingsManager.sessionGoal += 1
                } onDecrement: {
                    settingsManager.sessionGoal -= 1
                }

                TimerDurationStepper(forTimerState: .work, duration: $settingsManager.workTimerDuration)
                TimerDurationStepper(forTimerState: .rest, duration: $settingsManager.restTimerDuration)
                TimerDurationStepper(forTimerState: .longRest, duration: $settingsManager.longRestTimerDuration)

                Toggle("Start next timer automatically", isOn: $settingsManager.continuousMode)
            }

            Section {
                Toggle("Show notifications", isOn: $settingsManager.notificationsAreOn)

                Toggle("Play sound for notifications", isOn: $settingsManager.notificationSoundIsOn)
                    .disabled(!settingsManager.notificationsAreOn)

                Picker("Notification sound:", selection: $settingsManager.notificationSound) {
                    Text("Arp").tag(1)
                    Text("Bell").tag(0) // 'Bell' is the default
                    Text("Buzz").tag(2)
                    Text("Fourths").tag(3)
                    Text("Home").tag(4)
                    Text("Suspended").tag(5)
                }
                .disabled(!settingsManager.notificationSoundIsOn || !settingsManager.notificationsAreOn)
                .onChange(of: settingsManager.notificationSound) { newValue in
                    if let nextSound = NotificationSound(rawValue: newValue) {
                        playSound(for: nextSound)
                        NotificationManager.updateNotificationSound(to: nextSound)
                    }
                }
            }
        }
    }

    private func playSound(for notificationSound: NotificationSound) {
        let soundFile = notificationSound.fileName.replacingOccurrences(of: ".wav", with: "")
        guard let soundURL = Bundle.main.url(forResource: soundFile, withExtension: "wav") else {
            print("Sound file not found for: \(notificationSound.fileName).wav")
            return
        }

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayer?.play()
        } catch {
            print("Error playing sound: \(error)")
        }
    }

}

#Preview {
    return SettingsView(settingsManager: SettingsManager.shared)
}
