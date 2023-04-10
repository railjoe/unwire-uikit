//
//  AppDelegate.swift
//  unwire
//
//  Created by Jovan Stojanov on 10.4.23..
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var coordinator: SearchCoordinator?
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        let navigationController = UINavigationController()
        coordinator = SearchCoordinator(navigationController: navigationController)
        coordinator?.start()
        window?.rootViewController = navigationController
        
        return true
    }
}

