//
//  AppDelegate.swift
//  TaskListApp
//
//  Created by Max Kiselyov on 11/23/23.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    private var storageManager = StorageManager.shared // Добавили переменную стораж менежер
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {}
    
    // Сохраняем данные при закрытии приложения 
    func applicationWillTerminate(_ application: UIApplication) {
        storageManager.saveContext()
    }
}

