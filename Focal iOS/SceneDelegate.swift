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
        lastTimeWhenFocalResignedActive = Date()
        setApplicationShorcutItems()
        timerViewModel.updateUserDefaults()
        WidgetCenter.shared.reloadAllTimelines()
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        if let resignationTime = lastTimeWhenFocalResignedActive {
            let timeDifferenceBetweenResignationAndActivation = Date().timeIntervalSince(resignationTime)
            let correctedTimeRemaining =
                timerViewModel.timeRemaining - Int(timeDifferenceBetweenResignationAndActivation)

            // A negative correctedTimeRemaining means the timer has elapsed
            if correctedTimeRemaining < 0 {
                timerViewModel.timerState.toggle()
                timerViewModel.resetTimerDuration()
            }
            else {
                timerViewModel.timeRemaining = correctedTimeRemaining
            }
//            if settingsManager.startNextTimerAutomatically {
//                 TODO: later
//            }
        }
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
