//
//  AppDelegate.swift
//  SwiftUIKitDarkMode
//
//  Created by 林文峰 on 2023/2/25.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var nav = UINavigationController()
    var root = ViewController()
    public var window : UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.backgroundColor = .blue
        nav = UINavigationController(rootViewController: self.root)
        nav.navigationBar.backgroundColor = .blue
        self.window?.rootViewController = nav
        self.window?.makeKeyAndVisible()
        return true
    }

}

