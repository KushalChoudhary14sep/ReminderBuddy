//
//  HapticEngine.swift
//  ReminderBuddy
//
//  Created by Kushal Chaudhary on 15/06/24.
//

import Foundation
import UIKit

class HapticEngine: NSObject {
    static private let generator = UINotificationFeedbackGenerator()
    static private let selectionChangeGenerator = UISelectionFeedbackGenerator()
    static func generate(type: UINotificationFeedbackGenerator.FeedbackType) {
        generator.notificationOccurred(type)
    }
    static func generateImpact(type: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: type)
        generator.impactOccurred()
    }
    static func selectionChanged() {
        selectionChangeGenerator.selectionChanged()
    }
}
