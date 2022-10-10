//
//  AppDelegate.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/20.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = RepositoryListView()
        let storyboard = UIStoryboard(name: "RepositoryListView", bundle: nil)
        let vc = storyboard.instantiateInitialViewController() as? RepositoryListView
        guard let safeVC = vc else { return false}
        window.rootViewController = safeVC
        window.makeKeyAndVisible()
        return true
    }
}
