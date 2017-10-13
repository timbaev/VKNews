//
//  CoreDataManager.swift
//  VKNews
//
//  Created by Тимур Шафигуллин on 13.10.17.
//  Copyright © 2017 iOS Lab ITIS. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager {
    
    static let instance = CoreDataManager()
    
    private init() {}
    
    // MARK: - Core Data stack
    
    lazy var managedObjectContext: NSManagedObjectContext = {
       return persistentContainer.viewContext
    }()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "VKNews")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // MARK: - Core Data Entity Methods
    
    func entity(for name: String) -> NSEntityDescription {
        return NSEntityDescription.entity(forEntityName: name, in: self.managedObjectContext)!
    }
    
}
