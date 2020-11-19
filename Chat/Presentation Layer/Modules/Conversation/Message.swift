//
//  Message.swift
//  Chat
//
//  Created by Павел Левищев on 07.10.2020.
//  Copyright © 2020 p.levishchev. All rights reserved.
//

import Foundation
import Firebase

struct Message {
    let identifier: String
    let content: String
    let created: Date
    let senderId: String
    let senderName: String
}

extension Message {
    init?(data: [String: Any], documentID: String) {
        guard let content = data["content"] as? String,
            let timestamp = data["created"] as? Timestamp,
            let senderId = data["senderId"] as? String,
            let senderName = data["senderName"] as? String
            else { return nil }
        
        self.identifier = documentID
        self.content = content
        self.created = timestamp.dateValue()
        self.senderId = senderId
        self.senderName = senderName
    }
    
    init?(data: MessageDB) {
          guard let identifier = data.identifier, let content = data.content, let created = data.created,
              let senderId = data.senderId, let senderName = data.senderName else {
                  return nil
          }
          
          self.identifier = identifier
          self.content = content
          self.created = created
          self.senderId = senderId
          self.senderName = senderName
      }
}
