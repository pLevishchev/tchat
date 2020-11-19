//
//  SaveDataProtocol.swift
//  Chat
//
//  Created by Павел Левищев on 23.10.2020.
//  Copyright © 2020 p.levishchev. All rights reserved.
//

import Foundation
import UIKit
 
protocol SaveDataProtocol {
    func saveUser(user: UserModel, viewController: UIViewController, closure: @escaping () -> Void)
}
