//
//  GCDDataManager.swift
//  Chat
//
//  Created by Павел Левищев on 18.10.2020.
//  Copyright © 2020 p.levishchev. All rights reserved.
//

import Foundation
import UIKit

class GCDDataManager {
    let queue = DispatchQueue.global(qos: .utility)
    
    func saveTheme(closure: @escaping () -> Void) {
        queue.async {
           closure()
        }
    }
    
    func readDataFromFile(viewController: UIViewController, closure: @escaping () -> Void) {
        queue.async {
//            FileWriterService().readFile(viewController: viewController)
            DispatchQueue.main.async {
                closure()
            }
        }
    }
}

extension GCDDataManager: SaveDataProtocol {
    func saveUser(user: UserModel, viewController: UIViewController, closure: @escaping () -> Void) {
        queue.async {
            CoreDataManager.shared.saveUserToDB(user: user)
            DispatchQueue.main.async {
                closure()
            }
        }
    }
}
