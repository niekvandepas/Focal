//
//  SettingsManager.swift
//  Focal
//
//  Created by Niek van de Pas on 26/03/2024.
//

import SwiftUI

class SettingsManager: ObservableObject {
    static let shared = SettingsManager()
    private init() {}

    @AppStorage("showTimeLeft") var showTimeLeft = true
    @AppStorage("globalShortcutBringsAppToFront") var globalShortcutBringsAppToFront = false
    @AppStorage("hideAppOnTimerStart") var hideAppOnTimerStart = false
    @AppStorage("startNextTimerAutomatically") var startNextTimerAutomatically = false
    @AppStorage("timerWorkLabel") var optionalTimerWorkLabel = ""
    @AppStorage("timerBreakLabel") var optionalTimerBreakLabel = ""
    @AppStorage("sessionGoal") var sessionGoal = 4
}

