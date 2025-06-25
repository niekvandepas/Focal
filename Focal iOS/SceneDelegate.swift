//
//  SceneDelegate.swift
//  Focal iOS
//
//  Created by Niek van de Pas on 27/03/2024.
//

import UIKit
import WidgetKit

class SceneDelegate: NSObject, UIWindowSceneDelegate {
    let timerViewModel = TimerViewModel.shared
    let settingsManager = SettingsManager.shared
    var lastTimeWhenFocalResignedActive: Date? = nil

    func sceneWillResignActive(_ scene: UIScene) {
        logToFile("RESIGNING ACTIVE")
//        TODO I think the timer is only stopped after a couple of seconds (i.e. Focal is only really suspended after 3 seconds or so)
        // so we need to compensate for that.
//        lastTimeWhenFocalResignedActive = Date().addingTimeInterval(3)
        lastTimeWhenFocalResignedActive = Date()
        setApplicationShorcutItems()
        timerViewModel.updateUserDefaults()
        WidgetCenter.shared.reloadAllTimelines()
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        correctSuspendedTimerState()
    }

    func correctSuspendedTimerState() {
        logToFile("The time is now \(Date.now)")
        logToFile("time remaining at start: \(timerViewModel.timeRemaining)")
        guard timerViewModel.timerIsRunning else { return }

        guard let resignationTime = lastTimeWhenFocalResignedActive else { return }
        let timeSinceResignationInSeconds = Int(Date().timeIntervalSince(resignationTime))
        logToFile("timeSinceResignationInSeconds: \(timeSinceResignationInSeconds)")
        let correctedTimeRemaining =
            timerViewModel.timeRemaining - timeSinceResignationInSeconds

        // A non-negative time remaining means the timer is still running,
        // and we simply need to correct the time remaining.
        if correctedTimeRemaining > 0 {
            timerViewModel.timeRemaining = correctedTimeRemaining
            logToFile("time remaining at end: \(timerViewModel.timeRemaining)")
            return
        }

        // Otherwise, the last started timer has already elapsed.
        // In that case, if continuous mode is off, we simply reset the timer to the next timer state.
        if !settingsManager.continuousMode {
            timerViewModel.timerState = timerViewModel.getNextTimerState()
            timerViewModel.resetTimerDuration()
            logToFile("time remaining at end: \(timerViewModel.timeRemaining)")
            return
        }

        // If continuous mode is ON, things are a bit trickier:
        // we keep moving to the next timer state until
        // the overflow time is less than a full timer,
        // and then subtract the overflow time from the time remaining in the timer.
        var overflowTimeInSeconds = timeSinceResignationInSeconds
        var i = 0;

        while (overflowTimeInSeconds - timerViewModel.timeRemaining) >= 0 {
            logToFile("**************************************")
            logToFile("Staring iteration \(i)")

            let nextTimerState = timerViewModel.getNextTimerState()
            let nextTimeRemaining = SettingsManager.getTimerDuration(forTimerState: nextTimerState)
            let nextCompletedSessions = timerViewModel.getNextCompletedSessions()

            logToFile("overflowTimeInSeconds: \(overflowTimeInSeconds)")
            logToFile("overflowTimeInSeconds - timerViewModel.timeRemaining: \(overflowTimeInSeconds - timerViewModel.timeRemaining)")
            logToFile("The current timer state is: \(timerViewModel.timerState)")
            logToFile("nextTimerState: \(nextTimerState)")

            timerViewModel.timerState = nextTimerState

            logToFile("Setting timerViewModel.timeRemaining to: \(nextTimeRemaining)")
            timerViewModel.timeRemaining = nextTimeRemaining

            logToFile("Setting timerViewModel.completedSessions to: \(nextCompletedSessions)")
            timerViewModel.completedSessions = nextCompletedSessions

            overflowTimeInSeconds -= timerViewModel.timeRemaining
            logToFile("overflowTimeInSeconds after subtracting: \(overflowTimeInSeconds)")
            logToFile("**************************************\n")
            i += 1
        }

        timerViewModel.timeRemaining -= Int(overflowTimeInSeconds)
        logToFile("time remaining at end: \(timerViewModel.timeRemaining)")
    }

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        if let shortcutItem = connectionOptions.shortcutItem {
            handleShortcutItem(shortcutItem)
        }
    }

    func windowScene(_ windowScene: UIWindowScene, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        handleShortcutItem(shortcutItem)
        completionHandler(true)
    }

    private func setApplicationShorcutItems() {
        let application = UIApplication.shared

        let startTimerShortcutItem = UIApplicationShortcutItem(type: "START_TIMER", localizedTitle: "Start Timer", localizedSubtitle: nil, icon: UIApplicationShortcutIcon(systemImageName: "play"))
        let pauseTimerShortcutItem = UIApplicationShortcutItem(type: "PAUSE_TIMER", localizedTitle: "Pause Timer", localizedSubtitle: nil, icon: UIApplicationShortcutIcon(systemImageName: "pause"))
        let resetTimerShortcutItem = UIApplicationShortcutItem(type: "RESET_TIMER", localizedTitle: "Reset Timer", localizedSubtitle: nil, icon: UIApplicationShortcutIcon(systemImageName: "arrow.counterclockwise"))

        var shortCutItems = timerViewModel.timerIsRunning ? [pauseTimerShortcutItem] : [startTimerShortcutItem]

        if !timerViewModel.timerIsFull {
            shortCutItems.append(resetTimerShortcutItem)
        }

        application.shortcutItems = shortCutItems
    }

    private func handleShortcutItem(_ shortcutItem: UIApplicationShortcutItem) {
        switch shortcutItem.type {
        case "START_TIMER":
            timerViewModel.startTimer()
        case "PAUSE_TIMER":
            timerViewModel.pauseTimer()
        case "RESET_TIMER":
            timerViewModel.resetTimer()
        default:
            break
        }
    }
}

func logToFile(_ message: String) {
    let fileName = "app_debug_log.txt"
    let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(fileName)

    let timestamp = Date().description
    let logMessage = "[\(timestamp)] \(message)\n"

    do {
        if FileManager.default.fileExists(atPath: fileURL.path) {
            if let fileHandle = try? FileHandle(forWritingTo: fileURL) {
                fileHandle.seekToEndOfFile()
                if let data = logMessage.data(using: .utf8) {
                    fileHandle.write(data)
                }
                fileHandle.closeFile()
            }
        } else {
            try logMessage.write(to: fileURL, atomically: true, encoding: .utf8)
        }
    } catch {
        logToFile("Failed to write log: \(error)")
    }
}
