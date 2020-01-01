//
//  AppDelegate.swift
//  CircleHero
//
//  Created by Sroik on 8/4/15.
//  Copyright © 2015 Sroik. All rights reserved.
//

import SpriteKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        let gameController = GameViewController()
        self.window?.rootViewController = gameController
        
        self.window?.makeKeyAndVisible()
        
        return true
//        return ThirdParty.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
//    func applicationDidBecomeActive(_ application: UIApplication) {
//        ThirdParty.applicationDidBecomeActive(application)
//    }
//
//    func applicationWillEnterForeground(_ application: UIApplication) {
//        ThirdParty.applicationWillEnterForeground(application)
//    }
//
//    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
//        return ThirdParty.application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation as AnyObject)
//    }
   
}

