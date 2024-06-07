//
//  STTask.swift
//  Smart tasks
//
//  Created by Usman Saeed on 06/06/2024.
//

import Foundation
import CoreData

enum TaskStatus: String {
    case unresolved = "Unresolved"
    case resolved = "Resolved"
    case cantResolve = "Can't resolve"
}

struct TaskKeyed: Keyed {
    typealias Value = STTask
    static var key: String {
        return "tasks"
    }
}

@objc(STTask)
public class STTask: NSManagedObject, Codable {
    
    @NSManaged var id: String?
    @NSManaged var title: String?
    @NSManaged var taskDescription: String?
    @NSManaged var priority: Int16
    @NSManaged var status: String?

    @NSManaged var targetDate: Date?
    @NSManaged var dueDate: Date?

    enum CodingKeys: String, CodingKey {
        case id
        case targetDate = "TargetDate"
        case dueDate = "DueDate"
        case title = "Title"
        case taskDescription = "Description"
        case priority = "Priority"
        case status
    }

    // MARK: - Codable methods

    public required convenience init(from decoder: Decoder) throws {

        guard let entity = NSEntityDescription.entity(forEntityName: "STTask", in: PersistentStorage.shared.context) else {
            fatalError("Failed to decode Task entity.")
        }
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        if let id = try container.decodeIfPresent(String.self, forKey: .id) {
            if (fetchTask(with: id, in: PersistentStorage.shared.context) != nil) {
                self.init(entity: entity, insertInto: nil)
                return
            }
        }
                
        self.init(entity: entity, insertInto: PersistentStorage.shared.context)
                
        id = try container.decodeIfPresent(String.self, forKey: .id)
        title = try container.decodeIfPresent(String.self, forKey: .title)
        taskDescription = try container.decodeIfPresent(String.self, forKey: .taskDescription)
        
        if let priority = try container.decodeIfPresent(Int.self, forKey: .priority) {
            self.priority = Int16(priority)
        } else {
            self.priority = 0
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        if let targetDateString = try container.decodeIfPresent(String.self, forKey: .targetDate),
            let targetDate = dateFormatter.date(from: targetDateString) {
            self.targetDate = targetDate
        } else {
            self.targetDate = nil
        }
        
        if let dueDateString = try container.decodeIfPresent(String.self, forKey: .dueDate), let dueDate = dateFormatter.date(from: dueDateString) {
            self.dueDate = dueDate
        } else {
            self.dueDate = nil
        }
        
        self.status = TaskStatus.unresolved.rawValue
        
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(targetDate, forKey: .targetDate)
        try container.encode(dueDate, forKey: .dueDate)
        try container.encode(title, forKey: .title)
        try container.encode(taskDescription, forKey: .taskDescription)
        try container.encode(priority, forKey: .priority)
        try container.encode(status, forKey: .status)
    }
    
    
}

extension STTask {
    static func fetchRequest() -> NSFetchRequest<STTask> {
        return NSFetchRequest<STTask>(entityName: "STTask")
    }
}
