//
//  Constants.swift
//  Focal
//
//  Created by Niek van de Pas on 20/03/2024.
//

#if os(macOS)
import KeyboardShortcuts

extension KeyboardShortcuts.Name {
    static let toggleTimer = Self("toggleTimer")
}
#endif

struct Constants {
    static let UD_GROUP_NAME = "group.com.Focal"
    static let UD_TIME_REMAINING = "TimeRemaining"
    static let UD_TIMER_IS_RUNNING = "TimerIsRunning"
    static let UD_TIMER_STATE = "TimerIsRunning"
}

let EHTU = 5
