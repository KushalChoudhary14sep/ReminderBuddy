//
//  File.swift
//  ReminderBuddy
//
//  Created by Kushal Chaudhary on 15/06/24.
//

import Foundation
import UserNotifications
import FirebaseCore
import FirebaseMessaging
import FirebasePerformance

final class PushNotificationDelegate: NSObject, UIApplicationDelegate,UNUserNotificationCenterDelegate  {
    private override init() {
        super.init()
    }
    static var shared = PushNotificationDelegate()
    var fcmToken: String?
    var deviceToken: Data?
    
    @discardableResult func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        guard (Bundle.main.url(forResource: "GoogleService-Info", withExtension: "plist") != nil) else {
            return false
        }
        
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        Performance.sharedInstance().isDataCollectionEnabled = true
        registerForPushNotifications()
        return true
    }
    
    private func registerForPushNotifications() {
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
            (granted, error) in
            guard granted else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
        self.deviceToken = deviceToken
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        print("DEVICE TOKEN: ",token)
    }
}
extension PushNotificationDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        self.fcmToken = fcmToken
        print("FCM TOKEN: \(/fcmToken)")
    }
}
