//
//  ObjectsExtensions.swift
//  Chat
//
//  Created by p.levishchev on 05.11.2020.
//  Copyright © 2020 p.levishchev. All rights reserved.
//

import Foundation
import CoreData

extension UserDB {
    convenience init(user: UserModel,
                     in context: NSManagedObjectContext) {
        self.init(context: context)
        self.name = user.name
        self.bio = user.bio
        self.photo = user.photo?.pngData() ?? nil
    }
}

extension ChannelDB {
    convenience init(channel: Channel, in context: NSManagedObjectContext) {
        self.init(context: context)
        self.identifier = channel.identifier
        self.name = channel.name
        self.lastMessage = channel.lastMessage
        self.lastActivity = channel.lastActivity
    }
}

extension MessageDB {
    convenience init(message: Message, in context: NSManagedObjectContext) {
        self.init(context: context)
        self.identifier = message.identifier
        self.content = message.content
        self.created = message.created
        self.senderId = message.senderId
        self.senderName = message.senderName
    }
}
