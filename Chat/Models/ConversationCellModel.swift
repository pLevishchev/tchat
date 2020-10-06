//
//  Conversation.swift
//  Chat
//
//  Created by p.levishchev on 26.09.2020.
//  Copyright © 2020 p.levishchev. All rights reserved.
//

import Foundation

struct ConversationCellModel {
    var name: String
    var message: String?
    var date: Date
    var isOnline: Bool
    var hasUnreadMessages: Bool
    var avatar: Data?
}
