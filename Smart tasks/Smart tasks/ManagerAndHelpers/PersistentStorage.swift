//
//  PersistentStorage.swift
//  Smart tasks
//
//  Created by Usman Saeed on 06/06/2024.
//

import Foundation
import CoreData

final class PersistentStorage {
    private var coreDataManager : CoreDataManager!
    var context : NSManagedObjectContext!
    
    private init(){
        self.coreDataManager = CoreDataManager(modelName: "Smart_tasks")
        context = self.coreDataManager.mainManagedObjectContext
    }
    static let shared = PersistentStorage()

    // MARK: - Core Data Saving support
    func saveContext() {
        coreDataManager?.saveChanges()
    }

    func fetchManagedObject<T: NSManagedObject>(managedObject: T.Type) -> [T]? {
        do {
            guard let result = try PersistentStorage.shared.context.fetch(
                managedObject.fetchRequest()
            ) as? [T] else { return nil }
            
            return result
        } catch let error {
            debugPrint(error)
        }
        return nil
    }
    
    func printDocumentDirectoryPath() {
       debugPrint(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0])
    }
    
    func deleteObjects(entityName: String) {

        let fetchRequest: NSFetchRequest<NSFetchRequestResult>
        fetchRequest = NSFetchRequest(entityName: entityName)
        fetchRequest.returnsObjectsAsFaults = true

        do {
            let results = try PersistentStorage.shared.context.fetch(fetchRequest)
            for object in results {
                guard let objectData = object as? NSManagedObject else {continue}
                PersistentStorage.shared.context.delete(objectData)
            }
            
            PersistentStorage.shared.saveContext()
        } catch let error {
            print("Detele all data in \(entityName) error :", error)
        }
    }
}
