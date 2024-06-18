//
//  IQ.swift
//  ReminderBuddy
//
//  Created by BigOh on 18/06/24.
//

import Foundation
import IQKeyboardManager

class IQKeyboardManagerDelegate: NSObject, UIApplicationDelegate {
    private override init() {
        super.init()
    }
    static var shared = IQKeyboardManagerDelegate()
    
    @discardableResult func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        IQKeyboardManager.shared().isEnabled = true
        IQKeyboardManager.shared().shouldResignOnTouchOutside = true
        IQKeyboardManager.shared().keyboardDistanceFromTextField = 100
        IQKeyboardManager.shared().isEnableAutoToolbar = false
        
        return true
    }
}
