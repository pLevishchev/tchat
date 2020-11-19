//
//  ServicesAssembly.swift
//  Chat
//
//  Created by Павел Левищев on 18.11.2020.
//  Copyright © 2020 p.levishchev. All rights reserved.
//

import Foundation

protocol IServicesAssembly {
    var fileWriterService: IFileWriterService { get }
    var fireBaseManager: IFirebaseManager { get }
    var generator: IGenerator { get }
    var coreDataService: ICoreDataManager { get }

}

class ServicesAssembly: IServicesAssembly {
    
    lazy var fileWriterService: IFileWriterService = FileWriterService()
    lazy var fireBaseManager: IFirebaseManager = FirebaseManager()
    lazy var generator: IGenerator = Generator()
    lazy var coreDataService: ICoreDataManager = CoreDataManager.shared

}
