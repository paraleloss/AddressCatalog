//
//  SceneDelegate.swift
//  AddressesCatalog
//
//  Created by Saúl Pérez on 29/04/26.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        
        // Aquí es donde indicas cuál ViewController quieres que se abra primero
        let rootViewController = AddressListViewController()
        
        // Si quieres Navigation Controller (recomendado)
        let navigationController = UINavigationController(rootViewController: rootViewController)
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}
