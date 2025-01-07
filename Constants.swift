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
    static let UD_TIMER_STATE = "TimerState"
    static let UD_NEXT_TIMER_STATE = "NextTimerState"
    static let UD_SHOW_TIME_LEFT_SETTING = "ShowTimeLeftSetting"
    static let MAX_WORK_DURATION = 120 * 60
    static let MAX_REST_DURATION = 15 * 60
    static let MAX_LONG_REST_DURATION = 60 * 60
#if DEBUG
    static let MIN_WORK_DURATION = 1 * 60
    static let MIN_REST_DURATION = 1 * 60
    static let MIN_LONG_REST_DURATION = 1 * 60
#else
    static let MIN_WORK_DURATION = 1 * 60
    static let MIN_REST_DURATION = 1 * 60
    static let MIN_LONG_REST_DURATION = 5 * 60
#endif
}
