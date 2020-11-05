//
//  CoreDataStack.swift
//  Chat
//
//  Created by Павел Левищев on 02.11.2020.
//  Copyright © 2020 p.levishchev. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    var didUpdateDataBase: ((CoreDataStack) -> Void)?
    
    private var storeUrl: URL = {
        guard let documentsUrl = FileManager.default.urls(for: .documentDirectory,
                                                          in: .userDomainMask).last
            else { fatalError("document path not found") }
        return documentsUrl.appendingPathComponent("Chat.sqlite")
    }()
    
    private let dataModelName = "User"
    private let dataModelExtension = "momd"
    
    // MARK: - Core Data Stack
    
    private(set) lazy var managedObjectModel: NSManagedObjectModel = {
        guard let modelURL = Bundle.main.url(forResource: self.dataModelName,
                                             withExtension: self.dataModelExtension) else {
                                                fatalError("Unable to Find Data Model")
        }
        
        guard let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Unable to Load Data Model")
        }
        
        return managedObjectModel
    }()
    
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        
        let fileManager = FileManager.default
        let documentDirectoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        let storeName = "\(self.dataModelName).sqlite"
        let persistentStoreURL = documentDirectoryURL.appendingPathComponent(storeName)
        
        do {
            try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: .none, at: persistentStoreURL)
        } catch {
            fatalError("Unable to Load Persistent Store")
        }
        
        return persistentStoreCoordinator
    }()
    
    private lazy var writterContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.persistentStoreCoordinator = self.persistentStoreCoordinator
        context.mergePolicy = NSOverwriteMergePolicy
        
        return context
    }()
    
    private(set) lazy var mainContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.parent = writterContext
        context.automaticallyMergesChangesFromParent = true
        context.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        
        return context
    }()
    
    private func saveContext() -> NSManagedObjectContext {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.parent = mainContext
        context.automaticallyMergesChangesFromParent = true
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        return context
    }
    
    // MARK: - Public Methods
    
    /// Сохраняет блок данных.
    func save(_ block: (NSManagedObjectContext) -> Void) {
        let context = saveContext()
        
        context.performAndWait {
            block(context)
            
            if context.hasChanges {
                do {
                    try performSave(in: context)
                } catch {
                    print("Unable to Perform Save a Data")
                }
            }
        }
    }
    
    // MARK: - Private Methods
    
    /// Выполняет сохранение данных в контексте.
    private func performSave(in context: NSManagedObjectContext) throws {
        try context.save()
        
        if let parent = context.parent {
            try performSave(in: parent)
        }
    }
}
