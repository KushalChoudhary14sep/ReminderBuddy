//
//  AddTaskViewModel.swift
//  ReminderBuddy
//
//  Created by Kaushal Chaudhary on 16/06/24.
//

import Foundation
import CoreLocation

protocol AddTaskViewModelDelegates: AnyObject {
    func didAddTask()
}

class AddTaskViewModel {
    enum TaskConfigurationType: String {
        case edit = "Edit Task"
        case add = "New Task"
    }
    enum Sections: CaseIterable {
        case details
        case dueDate
        case location
        case priority
        case state
    }
    
    var title: String?
    var description: String?
    var dueDate: Date?
    var priority: UserTask.Priority = .medium
    var location: CLLocation?
    var address: String?
    var task: UserTask?
    var state: UserTask.State = .created
    var sections: [Sections] {
        var sections: [Sections] = [.details, .dueDate, .location, .priority]
        if let taskConfigurationType = taskConfigurationType {
            switch taskConfigurationType {
            case .edit:
                sections.append(.state)
            case .add:
                break
            }
        }
        return sections
    }
    var reminder: Bool = false
    var taskConfigurationType: TaskConfigurationType?

    weak var delegate: AddTaskViewModelDelegates?

    func updaTask() {
        guard let title = title, let description = description, let dueDate = dueDate else {
            if title == nil {
                ErrorDisplay.error(message: "Please enter title for the task!")
                return
            }
            if description == nil {
                ErrorDisplay.error(message: "Please enter description for the task!")
                return
            }
            return
        }
        task?.title = title
        task?.description = description
        task?.dueDate = dueDate
        task?.priority = priority
        task?.reminder = reminder
        task?.location = location
        task?.address = address
        task?.state = state
        if let task = task {
            TaskManager.shared.updateTask(task) { [weak self] in
                guard let self = self else { return }
                self.delegate?.didAddTask()
            }
        }
    }
    
    func addTask() {
        guard let title = title, let description = description, let dueDate = dueDate else {
            if title == nil {
                ErrorDisplay.error(message: "Please enter title for the task!")
                return
            }
            if description == nil {
                ErrorDisplay.error(message: "Please enter description for the task!")
                return
            }
            if dueDate == nil {
                ErrorDisplay.error(message: "Please enter the due date for the task!")
                return
            }
            return
        }
        TaskManager.shared.addTask(taskID: task?.id, title: title, description: description, dueDate: dueDate, priority: priority, location: location, address: address, reminder: reminder, state: state) { [weak self] in
            guard let self = self else { return }
            self.delegate?.didAddTask()
        }
    }
}
