//
//  UtilityFunctions.swift
//  Smart tasks
//
//  Created by Usman Saeed on 06/06/2024.
//

import Foundation
import CoreData
import UIKit

typealias TaskSortOrder = (STTask, STTask) -> Bool
typealias CommentSortOrder = (STComment, STComment) -> Bool

func sortTask(array: [STTask], predicates: [TaskSortOrder]) -> [STTask] {
    let _array = array.sorted { (lhs, rhs) in
        
        for predicate in predicates {
            
            if !predicate(lhs, rhs) && !predicate(rhs, lhs) {
                continue
            }
            return predicate(lhs, rhs)
        }
        return false
    }
    
    return _array
}

func sortComments(array: [STComment], predicates: [CommentSortOrder]) -> [STComment] {
    let _array = array.sorted { (lhs, rhs) in
        
        for predicate in predicates {
            
            if !predicate(lhs, rhs) && !predicate(rhs, lhs) {
                continue
            }
            return predicate(lhs, rhs)
        }
        return false
    }
    
    return _array
}

func formattedDateString(from date: Date) -> String {
    let calendar = Calendar.current
    let now = Date()
    
    let startOfToday = calendar.startOfDay(for: now)
    let startOfTomorrow = calendar.date(byAdding: .day, value: 1, to: startOfToday)!
    
    if calendar.isDate(date, inSameDayAs: startOfToday) {
        return "Today"
    } else if calendar.isDate(date, inSameDayAs: startOfTomorrow) {
        return "Tomorrow"
    }
    
    // Default date formatting
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MMM dd yyyy"
    dateFormatter.locale = Locale(identifier: "en_US")
    return dateFormatter.string(from: date)
}

func daysBetweenDates(dueDate: Date) -> Int? {
    let calendar = Calendar.current
    let components = calendar.dateComponents([.day], from: Date(), to: dueDate)
    return components.day
}


func fetchTask(with id: String?, in context: NSManagedObjectContext) -> STTask? {
    if let id {
        let fetchRequest: NSFetchRequest<STTask> = STTask.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        do {
            let tasks = try context.fetch(fetchRequest)
            return tasks.first
            
        } catch {
            print("Error fetching task with ID \(id)Expected STTask but found NSManagedObject: \(error.localizedDescription)")
            return nil
        }
    }else{
        return nil
    }
}

func fetchTasks() -> [STTask]? {
    let fetchRequest: NSFetchRequest<STTask> = STTask.fetchRequest()
    do {
        let tasks = try PersistentStorage.shared.context.fetch(fetchRequest)
        return tasks
    } catch {
        print("Error fetching tasks: \(error.localizedDescription)")
        return nil
    }
}

func fetchTasks(startOfDay: Date, endOfDay: Date) -> [STTask]? {
    let fetchRequest: NSFetchRequest<STTask> = STTask.fetchRequest()
    
    let predicate = NSPredicate(format: "(targetDate >= %@ AND targetDate <= %@)", startOfDay as NSDate, endOfDay as NSDate, startOfDay as NSDate, endOfDay as NSDate)
    fetchRequest.predicate = predicate

    do {
        let tasks = try PersistentStorage.shared.context.fetch(fetchRequest)
        return tasks
    } catch {
        print("Error fetching tasks: \(error.localizedDescription)")
        return nil
    }
}

func updateTaskStatus(taskId: String, newPriority: String) {
    guard let task = fetchTask(with: taskId, in: PersistentStorage.shared.context) else {
        print("Task with ID \(taskId) not found.")
        return
    }
    
    task.status = newPriority
    PersistentStorage.shared.saveContext()
}

func fetchCommentsForTask(with taskId: String) -> [STComment]? {
    let fetchRequest: NSFetchRequest<STComment> = STComment.fetchRequest()
    fetchRequest.predicate = NSPredicate(format: "taskid == %@", taskId)
    do {
        let tasks = try PersistentStorage.shared.context.fetch(fetchRequest)
        return tasks
        
    } catch {
        print("Error fetching task with ID \(taskId)Expected STComment but found NSManagedObject: \(error.localizedDescription)")
        return nil
    }
}

func getColorForStatus(status: String) -> UIColor {
    
    if status == TaskStatus.unresolved.rawValue {
        return #colorLiteral(red: 0.9764705882, green: 0.662745098, blue: 0.3960784314, alpha: 1)
    } else if status == TaskStatus.resolved.rawValue {
        return #colorLiteral(red: 0.05882352941, green: 0.4705882353, blue: 0.4078431373, alpha: 1)
    } else {
        return #colorLiteral(red: 0.937254902, green: 0.2941176471, blue: 0.368627451, alpha: 1)
    }
}

func getColorForPriority(priority: Int16) -> UIColor {
    
    if priority <= 1 {
        return #colorLiteral(red: 0.05882352941, green: 0.4705882353, blue: 0.4078431373, alpha: 1)
    } else if priority >= 2 && priority <= 3 {
        return #colorLiteral(red: 0.9764705882, green: 0.662745098, blue: 0.3960784314, alpha: 1)
    } else {
        return #colorLiteral(red: 0.937254902, green: 0.2941176471, blue: 0.368627451, alpha: 1)
    }
}
