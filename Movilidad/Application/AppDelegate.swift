//
//  AppDelegate.swift
//  Movilidad
//
//  Created by Diego Quimbo on 11/1/22.
//

import UIKit
import IQKeyboardManagerSwift
//import DropDown

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // Properties
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Handle Keyboard behaviour
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        
        // Handle Keyboard in DropDown
        DropDown.startListeningToKeyboard()
        
        // Load setting values from Settings.plist file
        RealmStorageManager.syncRealmDatabaseWithPlistFile()
        SettingsHandler.shared.loadData()
        
        setupInitialController()
        registerForPushNotifications()
        
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        print("Device Token: \(token)")
        SettingsHandler.shared.pushNotificationsToken = token
    }
}

// MARK: Private Functions
private extension AppDelegate {
    func setupInitialController() {
        window = UIWindow()
        window?.rootViewController = LoginBuilder.build()
        window?.makeKeyAndVisible()
    }
    
    func registerForPushNotifications() {
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound, .badge]) { [weak self] granted, _ in
                guard granted else { return }
                self?.getNotificationSettings()
            }
    }
    
    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
}
