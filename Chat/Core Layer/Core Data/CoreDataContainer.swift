//
//  CoreDataStack.swift
//  Chat
//
//  Created by Павел Левищев on 02.11.2020.
//  Copyright © 2020 p.levishchev. All rights reserved.
//

import Foundation
import CoreData

protocol ICoreDataContainer {
    var persistentContainer: NSPersistentContainer { get }
}

class CoreDataContainer: ICoreDataContainer {
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Chat")
        container.loadPersistentStores { _, error in
            
            if let error = error {
                fatalError("Unresolved error \(error.localizedDescription)")
            }
        }
        return container
    }()
}
