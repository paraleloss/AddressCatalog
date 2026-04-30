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

        let rootVC = AddressListViewController()
        let navigationController = UINavigationController(rootViewController: rootVC)
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}
