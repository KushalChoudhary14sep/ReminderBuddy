//
//  File.swift
//  ReminderBuddy
//
//  Created by Kaushal Chaudhary on 15/06/24.
//

import Foundation
import UIKit

prefix operator /
  prefix func /(str: Substring?) -> String{
    return String(str ?? "")
}
  prefix func /(str: Int64?) -> Int64{
    return str ?? Int64(0)
}
  prefix func /(str: String?) -> String {
    return str ?? ""
}
prefix func /(str: Character?) -> Character {
  return str ?? Character("")
}
  prefix func /(str: Int?) -> Int {
    return str ?? 0
}
  prefix func /(str: Bool?) -> Bool {
    return str ?? false
}
  prefix func /(str: Double?) -> Double {
    return str ?? 0.0
}

  prefix func /(str: Float?) -> Float {
    return str ?? 0.0
}

  prefix func /(str: CGFloat?) -> CGFloat {
    return str ?? 0.0
}

  prefix func /(str: URL?) -> URL {
    return str ?? URL(fileURLWithPath: "")
}

prefix func /(str: UIImage?) -> UIImage {
  return str ?? UIImage()
}
prefix func /(str: UIColor?) -> UIColor {
  return str ?? UIColor()
}

