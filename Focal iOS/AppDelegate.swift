//
//  AppDelegate.swift
//  Focal iOS
//
//  Created by Niek van de Pas on 28/03/2024.
//

import UIKit

class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        let sceneConfiguration = UISceneConfiguration(name: "Default configuration", sessionRole: connectingSceneSession.role)
        sceneConfiguration.delegateClass = SceneDelegate.self
        return sceneConfiguration
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // When the app terminates, the timer expects the timer to stop running.
        // Since notifications are scheduled ahead of time, we need to cancel them.
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
}
