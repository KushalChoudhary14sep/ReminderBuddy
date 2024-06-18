//
//  ErrorDisplay.swift
//  ReminderBuddy
//
//  Created by Kushal Chaudhary on 15/06/24.
//

import Foundation
import UIKit

class ErrorDisplay {
    static func error(message: String) {
        HapticEngine.generate(type: .error)
        
        NotificationView.show(font: UIFont.appfont(font: .semiBold, size: 12), text: message,timeout: 5.0, shouldCleanOldNotifications: true)
    }
}
