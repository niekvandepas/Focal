//
//  SettingsManager.swift
//  Focal
//
//  Created by Niek van de Pas on 26/03/2024.
//

import SwiftUI

@MainActor
final class SettingsManager: ObservableObject {
    static let shared = SettingsManager()
    private init() {}

    @AppStorage("showTimeLeft") var showTimeLeft = true
    @AppStorage("globalShortcutBringsAppToFront") var globalShortcutBringsAppToFront = false
    @AppStorage("hideAppOnTimerStart") var hideAppOnTimerStart = false
    @AppStorage("continuousMode") var continuousMode = false
    @AppStorage("notificationsAreOn") var notificationsAreOn = true
    @AppStorage("notificationSoundIsOn") var notificationSoundIsOn = true
    #if os(macOS)
    @AppStorage("showMenuBarIcon") var showMenuBarIcon = true
    @AppStorage("showTimeLeftInMenuBar") var showTimeLeftInMenuBar = false
    @AppStorage("showAppOnTimerElapse") var showAppOnTimerElapse = false
    #endif
    @AppStorage("notificationSound") var notificationSound = 0 // 'Bell' is the default
    @AppStorage("sessionGoal") var sessionGoal = 4

    @AppStorage("workTimerDuration") var workTimerDuration = 25 * 60
    @AppStorage("restTimerDuration") var restTimerDuration = 5 * 60
    @AppStorage("longRestTimerDuration") var longRestTimerDuration = 30 * 60
}

