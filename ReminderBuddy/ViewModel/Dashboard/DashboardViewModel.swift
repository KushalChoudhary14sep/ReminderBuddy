//
//  DashboardViewModel.swift
//  ReminderBuddy
//
//  Created by Kushal Chaudhary on 15/06/24.
//

import Foundation

class DashboardViewModel {
    
    
    
    var sections: [TaskManager.TaskType] {
        var sections: [TaskManager.TaskType] = []
        sections.append(.all)
        if !TaskManager.shared.getTasks(for: .dueTasks).isEmpty {
            sections.append(.dueTasks)
        }
        if !TaskManager.shared.getTasks(for: .upcoming).isEmpty {
            sections.append(.upcoming)
        }
        if !TaskManager.shared.getTasks(for: .completed).isEmpty {
            sections.append(.completed)
        }
        if !TaskManager.shared.getTasks(for: .inProgress).isEmpty {
            sections.append(.inProgress)
        }
        if !TaskManager.shared.getTasks(for: .created).isEmpty {
            sections.append(.created)
        }
        return sections
    }
    
    var tasks: [UserTask] {
        TaskManager.shared.tasks
    }
}
