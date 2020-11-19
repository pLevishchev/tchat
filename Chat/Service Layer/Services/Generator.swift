//
//  Generator.swift
//  Chat
//
//  Created by Павел Левищев on 31.10.2020.
//  Copyright © 2020 p.levishchev. All rights reserved.
//

import Foundation

protocol IGenerator {
    func uuid() -> String
}

class Generator: IGenerator {
    
    var userDefaults = UserDefaults.standard
    
    func uuid() -> String {
        if let uuid = userDefaults.string(forKey: "uuid") {
            return uuid
        } else {
            let uuid = UUID().uuidString
            userDefaults.set(uuid, forKey: "uuid")
            return uuid
        }
    }
}
