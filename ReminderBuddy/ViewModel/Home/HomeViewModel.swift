//
//  HomeViewModel.swift
//  ReminderBuddy
//
//  Created by Kushal Chaudhary on 15/06/24.
//

import Foundation

class HomeViewModel {
    
    var tasks: [UserTask] {
        return TaskManager.shared.getTasks()
    }
}
