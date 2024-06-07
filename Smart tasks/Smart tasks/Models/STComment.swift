//
//  Comment.swift
//  Smart tasks
//
//  Created by Usman Saeed on 06/06/2024.
//

import Foundation
import CoreData

@objc(STComment)
public class STComment: NSManagedObject {
    
    @NSManaged var id: String?
    @NSManaged var taskid: String?
    @NSManaged var username: String?
    @NSManaged var comment: String?
    @NSManaged var date: Date?

}

extension STComment {
    static func fetchRequest() -> NSFetchRequest<STComment> {
        return NSFetchRequest<STComment>(entityName: "STComment")
    }
}
