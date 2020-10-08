//
//  User.swift
//  Chat
//
//  Created by p.levishchev on 21.09.2020.
//  Copyright © 2020 p.levishchev. All rights reserved.
//

import Foundation

struct User {
    var firstName: String
    var lastName: String
    var bio: String
    
    init(firstName: String, lastName: String, bio: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.bio = bio
    }
    
    func firstLetters() -> String {
        return firstLetterName() + firstLetterLastName()
    }
    
    private func firstLetterName() -> String {
        guard let firstLetter = firstName.first else {
            return ""
        }
        
        return String(firstLetter)
    }
    
    private func firstLetterLastName() -> String {
        guard let secondLetter = lastName.first else {
            return ""
        }
        
        return String(secondLetter)
    }
}
