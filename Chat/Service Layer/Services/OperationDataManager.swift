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
    let operationQueue = OperationQueue()
}

class WriteDataOperation: Operation {
    let user: UserModel
    let viewController: UIViewController
    var result: Bool
    
    init(user: UserModel, viewController: UIViewController) {
        self.user = user
        self.viewController = viewController
        self.result = false
    }
    
    override func main() {
        FileWriterService().writeToFile(user: user, vc: viewController)
        result = true
    }
}

extension OperationDataManager: SaveDataProtocol {
    func saveUser(user: UserModel, viewController: UIViewController, closure: @escaping () -> Void) {
        let operation = WriteDataOperation(user: user, viewController: viewController)
        operationQueue.addOperation(operation)
        let operation2 = BlockOperation {
            if operation.result {
                closure()
            } else {
                print("При записи что-то пошло не так")
            }
        }
        operation2.addDependency(operation)
    }
}
