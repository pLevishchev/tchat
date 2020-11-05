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
