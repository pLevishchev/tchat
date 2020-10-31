//
//  AppDelegate.swift
//  Chat
//
//  Created by p.levishchev on 18.09.2020.
//  Copyright © 2020 p.levishchev. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, ILogger {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        UINavigationBar.appearance().barTintColor = ThemeManager.shared.currentTheme().backgroundColor

        if let window = window {
            let viewController = ChannelsListViewController()
            window.rootViewController = UINavigationController(rootViewController: viewController)
            window.makeKeyAndVisible()
        }
        FirebaseApp.configure()
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        log(from: "active", to: "inactive")
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        log(from: "foreground", to: "background")
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        log(from: "background", to: "foreground")
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        log(from: "inactive", to: "active")
        
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
    }
}
