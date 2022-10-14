//
//  AppDelegate.swift
//  NotifyMe
//
//  Created by RASHED on 10/6/22.
//

import UIKit
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }
    
    // Local notifications
    private func application(_ application: UIApplication, didReceive notification: UNUserNotificationCenter) {
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
}

