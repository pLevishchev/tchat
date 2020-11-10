//
//  Channel.swift
//  Chat
//
//  Created by Павел Левищев on 27.10.2020.
//  Copyright © 2020 p.levishchev. All rights reserved.
//

import Foundation
import Firebase

struct Channel {
    let identifier: String
    let name: String
    let lastMessage: String?
    let lastActivity: Date?
}

extension Channel {
    init?(data: [String: Any], documentID: String) {
        guard let name = data["name"] as? String else { return nil }
        let timestamp = data["lastActivity"] as? Timestamp
        let lastMessage = data["lastMessage"] as? String
        
        if (timestamp != nil && lastMessage == nil) || (timestamp == nil && lastMessage != nil) {
            return nil
        }
        
        self.identifier = documentID
        self.name = name
        self.lastMessage = lastMessage
        self.lastActivity = timestamp?.dateValue()
    }
    
    init?(data: ChannelDB) {
        guard let identifier = data.identifier,
            let name = data.name,
            let lastMessage = data.lastMessage,
            let lastActivity = data.lastActivity else {
                return nil
        }
        
        self.identifier = identifier
        self.name = name
        self.lastMessage = lastMessage
        self.lastActivity = lastActivity
    }
}
