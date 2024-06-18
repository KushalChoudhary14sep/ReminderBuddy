//
//  CoreDataManager.swift
//  ReminderBuddy
//
//  Created by Kushal Chaudhary on 16/06/24.
//

import Foundation
import CoreData
import CoreLocation

class CoreDataManager {
    
    private init() {}
    static let shared = CoreDataManager()
    
    private(set) var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataEntity")
        container.loadPersistentStores { (description, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func saveUser(id: String, email: String?, firstName: String?, lastName: String?) {
        let user = fetchUser(byId: id) ?? UserEntity(context: context)
        user.id = id
        user.email = email
        user.firstName = firstName
        user.lastName = lastName
        saveContext()
        UserDefaults.standard.set(id, forKey: "currentUserID")
    }
    
    func fetchCurrentUser() -> UserEntity? {
        if let currentUserID = UserDefaults.standard.string(forKey: "currentUserID") {
            return fetchUser(byId: currentUserID)
        }
        return nil
    }
    
    
    
    func deleteCurrentUser() {
        if let currentUserID = UserDefaults.standard.string(forKey: "currentUserID") {
            deleteUser(byId: currentUserID)
        }
    }
    
    func fetchUser(byId id: String) -> UserEntity? {
        let fetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        
        do {
            let users = try context.fetch(fetchRequest)
            return users.first // Assuming user IDs are unique
        } catch {
            print("Error fetching user with id \(id): \(error)")
            return nil
        }
    }
    
    func deleteUser(byId id: String) {
        if let user = fetchUser(byId: id) {
            context.delete(user)
            saveContext()
        }
    }
    
    
    func saveTask(_ task: UserTask, forUser user: UserEntity) {
        if let existingTask = fetchTask(byId: task.id) {
            existingTask.title = task.title
            existingTask.taskDescription = task.description
            existingTask.dueDate = task.dueDate
            existingTask.priority = task.priority.rawValue
            existingTask.createdDate = task.createdDate
            existingTask.state = task.state.rawValue
            existingTask.user = user
            existingTask.reminder = task.reminder
            existingTask.address = task.address
            existingTask.calendarEventIdentifier = task.calendarEventIdentifier
            if let location = task.location {
                existingTask.latitude = location.coordinate.latitude
                existingTask.longitude = location.coordinate.longitude
            } else {
                existingTask.latitude = 0
                existingTask.longitude = 0
            }
        } else {
            let newTask = TaskEntity(context: context)
            newTask.id = task.id
            newTask.title = task.title
            newTask.taskDescription = task.description
            newTask.dueDate = task.dueDate
            newTask.priority = task.priority.rawValue
            newTask.createdDate = task.createdDate
            newTask.state = task.state.rawValue
            newTask.user = user
            newTask.address = task.address
            newTask.reminder = task.reminder
            newTask.calendarEventIdentifier = task.calendarEventIdentifier
            if let location = task.location {
                newTask.latitude = location.coordinate.latitude
                newTask.longitude = location.coordinate.longitude
            } else {
                newTask.latitude = 0
                newTask.longitude = 0
            }
        }
        saveContext()
    }
    
    func fetchTasks(forUser user: UserEntity) -> [UserTask] {
        let fetchRequest: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "user == %@", user)
        
        do {
            let taskEntities = try context.fetch(fetchRequest)
            return taskEntities.compactMap { entity in
                guard let id = entity.id,
                      let title = entity.title,
                      let description = entity.taskDescription,
                      let dueDate = entity.dueDate,
                      let priorityRawValue = entity.priority,
                      let priority = UserTask.Priority(rawValue: priorityRawValue),
                      let createdDate = entity.createdDate,
                      let stateRawValue = entity.state,
                      let state = UserTask.State(rawValue: stateRawValue) else {
                    return nil
                }
                
                let location: CLLocation?
                if entity.latitude != 0.0 || entity.longitude != 0.0 {
                    location = CLLocation(latitude: entity.latitude, longitude: entity.longitude)
                } else {
                    location = nil
                }
                
                return UserTask(id: id,
                                title: title,
                                description: description,
                                dueDate: dueDate,
                                priority: priority,
                                createdDate: createdDate,
                                state: state,
                                location: location,
                                address: entity.address,
                                reminder: entity.reminder,
                                calendarEventIdentifier: entity.calendarEventIdentifier
                )
            }
        } catch {
            print("Failed to fetch tasks: \(error)")
            return []
        }
    }
    
    
    func fetchTask(byId id: String) -> TaskEntity? {
        let fetchRequest = NSFetchRequest<TaskEntity>(entityName: "TaskEntity")
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        do {
            return try context.fetch(fetchRequest).first
        } catch {
            print("Failed to fetch task: \(error)")
            return nil
        }
    }
    
    func deleteTask(byId id: String) {
        if let task = fetchTask(byId: id) {
            context.delete(task)
            saveContext()
        }
    }
    
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
                if let user = UserManager.shared.currentUser {
                    print(fetchTasks(forUser: user))
                }
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
