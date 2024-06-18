//
//  TaskDetailViewModel.swift
//  ReminderBuddy
//
//  Created by Kushal Chaudhary on 16/06/24.
//

import Foundation

protocol TaskDetailViewModelDelegates: AnyObject {
    func didDeleteTask()
}

class TaskDetailViewModel {
    
    enum TaskDetailSections: CaseIterable {
        case detail
//        case dateAndPriority
    }
    
    var sections: [TaskDetailSections] = [.detail]
    
    var task: UserTask?
    
    weak var delegate: TaskDetailViewModelDelegates?
    
    func deleteTask() {
        TaskManager.shared.removeTask(withId: /task?.id) { [weak self] in
            self?.delegate?.didDeleteTask()
        }
    }
}
