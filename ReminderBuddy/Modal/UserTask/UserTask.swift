//
//  UserEntity.swift
//  ReminderBuddy
//
//  Created by Kaushal Chaudhary on 16/06/24.
//

import Foundation
import CoreLocation
import CoreData

class UserTask {
    var id: String
    var title: String
    var description: String
    var dueDate: Date
    var priority: Priority
    var createdDate: Date
    var state: State
    var location: CLLocation?
    var address: String?
    var reminder: Bool
    
    init(id: String, title: String, description: String, dueDate: Date, priority: Priority, createdDate: Date, state: State, location: CLLocation?, address: String?, reminder: Bool) {
        self.id = id
        self.title = title
        self.description = description
        self.dueDate = dueDate
        self.priority = priority
        self.createdDate = createdDate
        self.state = state
        self.location = location
        self.address = address
        self.reminder = reminder
    }
    
    enum Priority: String, CaseIterable {
        case low = "Low"
        case medium = "Medium"
        case high = "High"
    }
    
    enum State: String, CaseIterable {
        case created = "Created"
        case inProgress = "In Progress"
        case completed = "Completed"
    }
}
