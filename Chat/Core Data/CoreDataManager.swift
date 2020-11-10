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
    let coreDataStack = CoreDataStack()
    
    // MARK: - Functions
    func saveUserToDB(user: UserModel) {
        coreDataStack.save { context in
            _ = UserDB(user: user, in: context)
        }
    }
    
    func saveChannelsToDB(channels: [Channel]) {
        coreDataStack.save { context in
            _ = channels.map { ChannelDB(channel: $0, in: context) }
        }
    }
    
    func saveMessagesToDB(channelID: String, messages: [Message]) {
        coreDataStack.save { context in
            let fetchRequest: NSFetchRequest<ChannelDB> = ChannelDB.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "identifier = %@", channelID)
            let results = try? context.fetch(fetchRequest)
            if let channel = results?.first {
                let messagesDB = messages.map { MessageDB(message: $0, in: context) }
                messagesDB.forEach { channel.addToMessage($0) }
            }
        }
    }
    
    func fetchUser() -> UserModel {
        var user = UserModel(name: "Имя пользователя", bio: "Расскажите о себе", photo: nil)
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: UserDB.self))
        do {
            if let result = try coreDataStack.mainContext.fetch(request) as? [UserDB] {
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

}
