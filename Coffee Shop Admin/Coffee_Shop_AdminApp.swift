//
//  Coffee_Shop_AdminApp.swift
//  Coffee Shop Admin
//
//  Created by constantine kos on 09.10.2020.
//

import SwiftUI
import Firebase

@main
struct Coffee_Shop_AdminApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegateAdaptor
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}


class AppDelegate: UIResponder, UIApplicationDelegate {
    // MARK: - User Notifications via PushNotificationManager
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        application.applicationIconBadgeNumber = 0
    }
}
