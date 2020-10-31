//
//  Channel.swift
//  Chat
//
//  Created by Павел Левищев on 27.10.2020.
//  Copyright © 2020 p.levishchev. All rights reserved.
//

import Foundation

struct Channel {
    let identifier: String
    let name: String
    let lastMessage: String?
    let lastActivity: Date?
}
