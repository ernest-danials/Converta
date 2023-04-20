//
//  PersistantController.swift
//  Converta
//
//  Created by Ernest Dainals on 07/03/2023.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()
    
    let container: NSPersistentContainer
    
    init() {
        container = NSPersistentCloudKitContainer(name: "Library")
        
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("An error has occured while loading PersistentStores. Error: \(error)")
            }
        }
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
}
