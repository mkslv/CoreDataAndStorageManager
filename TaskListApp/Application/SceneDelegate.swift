//
//  SceneDelegate.swift
//  TaskListApp
//
//  Created by Max Kiselyov on 11/23/23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private var storageManager = StorageManager.shared // Доб. переменную стораж менежер 

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        let navVC = UINavigationController(rootViewController: TaskListViewController())
        window?.rootViewController = navVC
        window?.makeKeyAndVisible()
    }
    
    // Сохраняем данные при скрытии приложения в бекграунде
    func sceneDidEnterBackground(_ scene: UIScene) {
        storageManager.saveContext()
    }
}
