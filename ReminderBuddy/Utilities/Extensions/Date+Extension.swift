//
//  Date+Extension.swift
//  ReminderBuddy
//
//  Created by Kushal Chaudhary on 16/06/24.
//

import Foundation

extension Date {
    func formatDateToString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM, yyyy" // Desired format: "12 Jun, 2024"
        return dateFormatter.string(from: self)
    }
    
    func formatToDisplay() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM, yyyy"
        return formatter.string(from: self)
    }
}
