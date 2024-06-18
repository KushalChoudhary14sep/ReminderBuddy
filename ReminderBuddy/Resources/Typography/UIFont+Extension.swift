//
//  File.swift
//  ReminderBuddy
//
//  Created by Kaushal Chaudhary on 15/06/24.
//

import Foundation
import UIKit

extension UIFont {
    enum FontWeight {
        case regular
        case medium
        case black
        case semiBold
        case bold
        case extraBold
    }
    
    static func appfont(font: FontWeight, size: CGFloat) -> UIFont {
        switch font {
        case .semiBold:
            return UIFont(name: "Poppins-SemiBold", size: size)!
        case .regular:
            return UIFont(name: "Poppins-Regular", size: size)!
        case .black:
            return UIFont(name: "Poppins-Black", size: size)!
        case .medium:
            return UIFont(name: "Poppins-Medium", size: size)!
        case .bold:
            return UIFont(name: "Poppins-Bold", size: size)!
        case .extraBold:
            return UIFont(name: "Poppins-ExtraBold", size: size)!
        }
    }
}
