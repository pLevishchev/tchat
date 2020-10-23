//
//  UserModel.swift
//  Chat
//
//  Created by p.levishchev on 21.09.2020.
//  Copyright © 2020 p.levishchev. All rights reserved.
//

import UIKit

struct UserModel {
    var name: String
    var bio: String
    var photo: UIImage?
    
    init(name: String, bio: String, photo: UIImage?) {
        self.name = name
        self.bio = bio
        self.photo = photo
    }

    func firstLetterName() -> String {
        guard let firstLetter = name.first else {
            return ""
        }
        return String(firstLetter)
    }
}
