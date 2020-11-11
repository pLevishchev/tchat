//
//  CoreDataManager.swift
//  Chat
//
//  Created by p.levishchev on 05.11.2020.
//  Copyright © 2020 p.levishchev. All rights reserved.
//

import Foundation
import CoreData
import UIKit

protocol ICoreDataManager {
    func fetchUser() -> UserModel
    func saveUserToDB(user: UserModel)
    func saveChannelsToDB(channels: [Channel])
}

class CoreDataManager: ICoreDataManager {
    
    static let shared = CoreDataManager()
    private init() {}
    
    // MARK: - Properties
    let context = CoreDataContainer().persistentContainer.viewContext
    
    // MARK: - Functions
    func saveUserToDB(user: UserModel) {
        _ = UserDB(user: user, in: context)
        saveContext()
    }
    
    func saveChannelsToDB(channels: [Channel]) {
        removeChannels()
        _ = channels.map { ChannelDB(channel: $0, in: context)
        }
        
        saveContext()
    }
    
    func saveContext() {
        do {
            try context.save()
            print("Context is saved")
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func saveMessagesToDB(channelID: String, messages: [Message]) {
        let fetchRequest: NSFetchRequest<ChannelDB> = ChannelDB.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier = %@", channelID)
        let results = try? context.fetch(fetchRequest)
        if let channel = results?.first {
            let messagesDB = messages.map { MessageDB(message: $0, in: context) }
            messagesDB.forEach { channel.addToMessage($0) }
        }
        saveContext()
    }
    
    func fetchUser() -> UserModel {
        var user = UserModel(name: "Имя пользователя", bio: "Расскажите о себе", photo: nil)
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: UserDB.self))
        do {
            if let result = try context.fetch(request) as? [UserDB] {
                guard let userFromDB = result.last else { return user }
                user.name = userFromDB.name ?? user.name
                user.bio = userFromDB.bio ?? user.bio
                if let image = userFromDB.photo {
                    user.photo = UIImage(data: image)
                } else {
                    user.photo = nil
                }
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return user
    }
    
    func removeChannels() {
        let fetchRequest: NSFetchRequest<ChannelDB> = ChannelDB.fetchRequest()
        let results = try? context.fetch(fetchRequest)
        results?.forEach({ (channel) in
            context.delete(channel)
        })
    }
    
    func removeMessages() {
        let fetchRequest: NSFetchRequest<MessageDB> = MessageDB.fetchRequest()
        let results = try? context.fetch(fetchRequest)
        results?.forEach({ (message) in
            context.delete(message)
        })
    }
}
