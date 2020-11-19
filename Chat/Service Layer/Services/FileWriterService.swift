//
//  FileWriterService.swift
//  Chat
//
//  Created by Павел Левищев on 18.10.2020.
//  Copyright © 2020 p.levishchev. All rights reserved.
//

import Foundation
import UIKit

protocol IFileWriterService {
    func writeToFile(user: UserModel, vc: IShowAlert)
    func readFile(viewController: IShowAlert) -> UserModel?
}

class FileWriterService: IFileWriterService {
    
    lazy var fileManager = FileManager.default

    var fileName: URL {
        fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("name.txt")
    }
    
    var fileBio: URL {
        fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("bio.txt")
    }
    var photoFile: URL {
        fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("photo.txt")
    }
    
    func writeToFile(user: UserModel, vc: IShowAlert) {
        do {
            let name = user.name
            let bio = user.bio
            if let photo = user.photo {
                try photo.pngData()?.write(to: photoFile)
            }
            try name.write(to: fileName, atomically: true, encoding: .utf8)
            try bio.write(to: fileBio, atomically: true, encoding: .utf8)
        } catch {
            vc.presentAlertOnMainThread(title: "Ошибка",
                                                    message: "Не удалось сохранить данные",
                                                    type: .fail)
        }
    }
    
    func readFile(viewController: IShowAlert) -> UserModel? {
        if fileManager.fileExists(atPath: fileName.path) ||
           fileManager.fileExists(atPath: fileBio.path) ||
           fileManager.fileExists(atPath: photoFile.path) {
            do {
                let name = try String(contentsOf: fileName, encoding: .utf8)
                let bio = try String(contentsOf: fileBio, encoding: .utf8)
                let photo = (try? Data(contentsOf: photoFile)) ?? Data()
                
                return UserModel(name: name, bio: bio, photo: UIImage(data: photo))
            } catch {
                viewController.presentAlertOnMainThread(title: "Ошибка",
                                                        message: "Не удалось прочитать данные",
                                                        type: .fail)
            }
        }
        return nil
    }
}
