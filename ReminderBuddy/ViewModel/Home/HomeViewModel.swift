//
//  HomeViewModel.swift
//  ReminderBuddy
//
//  Created by Kaushal Chaudhary on 15/06/24.
//

import Foundation

class HomeViewModel {
    
    var tasks: [UserTask] {
        return TaskManager.shared.getTasks()
    }
}
