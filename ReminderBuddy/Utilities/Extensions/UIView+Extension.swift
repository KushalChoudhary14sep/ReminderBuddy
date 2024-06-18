//
//  UIView+Extension.swift
//  ReminderBuddy
//
//  Created by Kaushal Chaudhary on 16/06/24.
//

import Foundation
import UIKit

struct ShadowSides: OptionSet {
    let rawValue: Int

    static let top = ShadowSides(rawValue: 1 << 0)
    static let bottom = ShadowSides(rawValue: 1 << 1)
    static let leading = ShadowSides(rawValue: 1 << 2)
    static let trailing = ShadowSides(rawValue: 1 << 3)

    static let all: ShadowSides = [.top, .bottom, .leading, .trailing]
}

extension UIView {
    func addShadow(to sides: ShadowSides, shadowColor: UIColor = .black.withAlphaComponent(0.05),
                   shadowOpacity: Float = 1, shadowRadius: CGFloat = 3) {

        layer.masksToBounds = false
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = shadowRadius
        layer.shadowOffset = .zero
        let width = bounds.width
        let height = bounds.height

        var shadowRect: CGRect?

        if sides.contains(.top) {
            shadowRect = CGRect(x: 0, y: -shadowRadius, width: width, height: shadowRadius)
        }
        if sides.contains(.bottom) {
            if let existingShadowRect = shadowRect {
                shadowRect = existingShadowRect.union(CGRect(x: 0, y: height, width: width, height: shadowRadius))
            } else {
                shadowRect = CGRect(x: 0, y: height, width: width, height: shadowRadius)
            }
        }
        if sides.contains(.leading) {
            if let existingShadowRect = shadowRect {
                shadowRect = existingShadowRect.union(CGRect(x: -shadowRadius, y: 0, width: shadowRadius, height: height))
            } else {
                shadowRect = CGRect(x: -shadowRadius, y: 0, width: shadowRadius, height: height)
            }
        }
        if sides.contains(.trailing) {
            if let existingShadowRect = shadowRect {
                shadowRect = existingShadowRect.union(CGRect(x: width, y: 0, width: shadowRadius, height: height))
            } else {
                shadowRect = CGRect(x: width, y: 0, width: shadowRadius, height: height)
            }
        }

        if let shadowRect = shadowRect {
            layer.shadowPath = UIBezierPath(rect: shadowRect).cgPath
        }
    }
}

extension UIView {
    var parentViewController: UIViewController? {
        var nextResponder: UIResponder? = self
        while nextResponder != nil {
            nextResponder = nextResponder?.next
            if let viewController = nextResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}
