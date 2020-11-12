//
//  CoreDataStack.swift
//  Chat
//
//  Created by Павел Левищев on 02.11.2020.
//  Copyright © 2020 p.levishchev. All rights reserved.
//

import Foundation
import CoreData

class CoreDataContainer {
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Chat")
        container.loadPersistentStores { _, error in
            
            if let error = error {
                fatalError("Unresolved error \(error.localizedDescription)")
            }
        }
        return container
    }()
    
    func saveContext() {
        let context = persistentContainer.viewContext
        
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                fatalError()
            }
        }
    }
}
