//
//  CalendarManager.swift
//  ReminderBuddy
//
//  Created by BigOh on 18/06/24.
//

import Foundation
import EventKit
import CoreLocation

class CalendarManager {
    
    static let shared = CalendarManager()
    private let eventStore = EKEventStore()
    
    private init() {}
    
    func requestCalendarAccess() {
        eventStore.requestAccess(to: .event) { (granted, error) in
            if !granted || error != nil {
                print("Calendar access denied or error: \(String(describing: error?.localizedDescription))")
            }
        }
    }
    
    func addEvent(for task: UserTask, completion: ((Bool) -> Void)? = nil) {
        guard let calendar = eventStore.defaultCalendarForNewEvents else {
            completion?(false)
            return
        }
        
        let event = EKEvent(eventStore: eventStore)
        event.title = task.title
        event.notes = task.description
        event.startDate = task.dueDate
        event.endDate = task.dueDate.addingTimeInterval(3600)
        event.calendar = calendar
        
        if let location = task.address {
            event.location = location
        }
        
        if task.reminder {
            if let alarmDate = getAlarmDate(for: task.dueDate) {
                let alarm = EKAlarm(absoluteDate: alarmDate)
                event.addAlarm(alarm)
            }
        }
        
        do {
            try eventStore.save(event, span: .thisEvent, commit: true)
            task.calendarEventIdentifier = event.eventIdentifier
            TaskManager.shared.updateTask(task) {
                completion?(true)
            }
        } catch {
            print("Failed to save event with error: \(error.localizedDescription)")
            completion?(false)
        }
    }
    
    func updateEvent(for task: UserTask, completion: ((Bool) -> Void)? = nil) {
        guard let eventIdentifier = task.calendarEventIdentifier else {
            addEvent(for: task, completion: completion)
            return
        }
        
        if let event = eventStore.event(withIdentifier: eventIdentifier) {
            event.title = task.title
            event.notes = task.description
            event.startDate = task.dueDate
            event.endDate = task.dueDate.addingTimeInterval(3600)
            
            if let location = task.address {
                event.location = location
            }
            
            event.alarms?.removeAll()
            
            if task.reminder {
                if let alarmDate = getAlarmDate(for: task.dueDate) {
                    let alarm = EKAlarm(absoluteDate: alarmDate)
                    event.addAlarm(alarm)
                }
            }
            
            do {
                try eventStore.save(event, span: .thisEvent, commit: true)
                completion?(true)
            } catch {
                print("Failed to update event with error: \(error.localizedDescription)")
                completion?(false)
            }
        } else {
            addEvent(for: task, completion: completion)
        }
    }
    
    func deleteEvent(for task: UserTask, completion: ((Bool) -> Void)? = nil) {
        guard let eventIdentifier = task.calendarEventIdentifier else {
            print("No event identifier for task: \(task.title)")
            completion?(false)
            return
        }
        
        DispatchQueue.global().async {
            self.eventStore.refreshSourcesIfNecessary()
            DispatchQueue.main.async {
                if let event = self.eventStore.event(withIdentifier: eventIdentifier) {
                    print("Event found for identifier: \(eventIdentifier), attempting to delete.")
                    
                    do {
                        try self.eventStore.remove(event, span: .thisEvent, commit: true)
                        print("Event deleted successfully from calendar.")
                        task.calendarEventIdentifier = nil
                        TaskManager.shared.updateTask(task) {
                            print("Task updated without calendar event identifier.")
                            completion?(true)
                        }
                    } catch {
                        print("Failed to delete event with error: \(error.localizedDescription)")
                        completion?(false)
                    }
                } else {
                    print("Event not found with identifier: \(eventIdentifier). It may have already been deleted.")
                    task.calendarEventIdentifier = nil
                    TaskManager.shared.updateTask(task) {
                        completion?(true)
                    }
                }
            }
        }
    }
    
    private func getAlarmDate(for dueDate: Date) -> Date? {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone.current
        var components = calendar.dateComponents([.year, .month, .day], from: dueDate)
        components.hour = 10
        components.minute = 0
        return calendar.date(from: components)
    }
}
