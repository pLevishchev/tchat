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
    
    func writeDataToFile(user: UserModel, viewController: UIViewController, closure: @escaping () -> Void) {
        queue.async {
            FileWriterService().writeToFile(user: user, viewController: viewController)
            DispatchQueue.main.async {
                closure()
            }
        }
    }
    
    func readDataFromFile(viewController: UIViewController, closure: @escaping () -> Void) {
        queue.async {
//            FileWriterService().readFile(get: type, viewController: viewController)
            DispatchQueue.main.async {
                closure()
            }
        }
    }
}
