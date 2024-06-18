//
//  TaskManager.swift
//  ReminderBuddy
//
//  Created by Kaushal Chaudhary on 16/06/24.
//

import Foundation
import CoreLocation
import UserNotifications

class TaskManager {
    
    enum TaskType: String, CaseIterable {
        case all = "All"
        case completed = "Completed"
        case inProgress = "In Progress"
        case created = "Created"
        case upcoming = "Upcoming"
        case dueTasks = "Due"
    }
    
    static let shared = TaskManager()
    
    var tasks: [UserTask] {
        guard let currentUser = UserManager.shared.currentUser else { return [] }
        return CoreDataManager.shared.fetchTasks(forUser: currentUser)
    }
    
    private init() {
    }
    
    func getTasks(for section: TaskType) -> [UserTask] {
        switch section {
        case .completed:
            return tasks.filter({ $0.state == .completed })
        case .inProgress:
            return tasks.filter({ $0.state == .inProgress })
        case .created:
            return tasks.filter({ $0.state == .created })
        case .upcoming:
            return tasks.filter({ $0.dueDate > Date() })
        case .dueTasks:
            return tasks.filter({ $0.dueDate < Date() })
        case .all:
            return tasks
        }
    }
    
    func addTask(taskID: String?, title: String, description: String, dueDate: Date, priority: UserTask.Priority, location: CLLocation?, address: String?, reminder: Bool, state: UserTask.State, completion:  @escaping (() -> Void)) {
        guard let currentUser = UserManager.shared.currentUser else { return }
        let newTask = UserTask(id: taskID ?? UUID().uuidString, title: title, description: description, dueDate: dueDate, priority: priority, createdDate: Date(), state: state, location: location, address: address, reminder: reminder)
        CoreDataManager.shared.saveTask(newTask, forUser: currentUser)
        if newTask.reminder {
            scheduleNotification(for: newTask)
        }
        completion()
    }
    
    func getTasks() -> [UserTask] {
        return tasks
    }
    
    func getTask(withId id: String) -> UserTask? {
        return tasks.first(where: { $0.id == id })
    }
    
    func updateTask(_ updatedTask: UserTask, completion: @escaping (() -> Void)) {
        guard let currentUser = UserManager.shared.currentUser else { return }
        if tasks.firstIndex(where: { $0.id == updatedTask.id }) != nil {
            CoreDataManager.shared.saveTask(updatedTask, forUser: currentUser)
            if updatedTask.reminder {
                scheduleNotification(for: updatedTask)
            }
            completion()
        }
    }
    
    func removeTask(withId id: String, completion: @escaping (() -> Void)) {
        guard UserManager.shared.currentUser != nil else { 
            return
        }
        CoreDataManager.shared.deleteTask(byId: id)
        completion()
    }
    
    
    func scheduleNotification(for task: UserTask) {
        let content = UNMutableNotificationContent()
        content.title = "Task Reminder"
        content.body = "Don't forget: \(task.title) is due soon!"
        content.sound = UNNotificationSound.default
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: task.dueDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        
        let request = UNNotificationRequest(identifier: task.id, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification for task \(task.id): \(error.localizedDescription)")
            }
        }
    }
}
