//
//  UIViewController+Ext.swift
//  Chat
//
//  Created by Павел Левищев on 21.10.2020.
//  Copyright © 2020 p.levishchev. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func presentAlertOnMainThread(title: String, message: String?, type: TypeAlert) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        let cancelButton = UIAlertAction(title: "Отмена", style: .default, handler: nil)
        let repeatButton = UIAlertAction(title: "Повторить", style: .default, handler: nil)
        
        switch type {
        case .ok:
            ac.addAction(okAction)
        case .fail:
            ac.addAction(okAction)
            ac.addAction(repeatButton)
        case .withTextField:
            ac.addTextField { (textField) in
                textField.placeholder = "create new channel"
            }
            ac.addAction(okAction)
            ac.addAction(cancelButton)
        }
        self.present(ac, animated: true, completion: nil)
    }
}

enum TypeAlert {
    case ok
    case fail
    case withTextField
}
