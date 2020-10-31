//
//  OperationDataManager.swift
//  Chat
//
//  Created by Павел Левищев on 18.10.2020.
//  Copyright © 2020 p.levishchev. All rights reserved.
//

import Foundation
import UIKit

class OperationDataManager: Operation {
    
    let user: UserModel
    let viewController: UIViewController
        
    init(user: UserModel, viewController: UIViewController) {
        self.user = user
        self.viewController = viewController
    }
        
    override func main() {
        FileWriterService().writeToFile(user: user, viewController: viewController)
    }
}

extension OperationDataManager: SaveDataProtocol {
    func saveUser(user: UserModel, viewController: UIViewController, closure: @escaping () -> Void) {
        let operation = OperationDataManager(user: user, viewController: viewController)
        let opQueue = OperationQueue()
        OperationQueue.main.addOperation {
            closure()
        }
        opQueue.addOperation(operation)

    }
}
