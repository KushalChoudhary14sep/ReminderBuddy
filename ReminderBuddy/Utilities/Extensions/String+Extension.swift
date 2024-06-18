//
//  String+Extension.swift
//  ReminderBuddy
//
//  Created by Kaushal Chaudhary on 15/06/24.
//

import Foundation
import UIKit

extension String {
    var localised: String {
       return NSLocalizedString(self, comment: self)
    }
    var localisedNumber: String {
        var str = ""
        for char in self {
            let formatter: NumberFormatter = NumberFormatter()
            formatter.locale = NSLocale(localeIdentifier: "EN") as Locale
            let final = formatter.number(from: String(char))
            str = str + (final?.stringValue ?? String(char))
        }
        return str
    }
}

extension NSAttributedString {
    static func setAttributedText(text: String, font: UIFont, color: UIColor, additionalAttributes: [NSAttributedString.Key: Any] = [:], range: NSRange? = nil) -> NSAttributedString {
        var attributes: [NSAttributedString.Key: Any] = [
                .font: font,
                .foregroundColor: color
            ]
        attributes.merge(additionalAttributes) { (_, new) in new }
        let string = NSMutableAttributedString(string: text, attributes: attributes)
        if let range = range {
               let additionalAttributedString = NSAttributedString(string: text, attributes: additionalAttributes)
            string.addAttributes(additionalAttributedString.attributes(at: 0, effectiveRange: nil), range: range)
        }
        return string
    }
}
