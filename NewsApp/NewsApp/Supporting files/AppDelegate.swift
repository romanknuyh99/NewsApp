//
//  AppDelegate.swift
//  NewsApp
//
//  Created by Roman Kniukh on 21.03.21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        self.window = UIWindow(frame: UIScreen.main.bounds)

        if let window = self.window {
            let navigationController = UINavigationController()
            navigationController.viewControllers = [ViewController()]
            
            window.rootViewController = navigationController
            window.makeKeyAndVisible()
        }
    
        return true
    }
}

