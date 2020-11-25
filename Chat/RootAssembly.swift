//
//  RootAssembly.swift
//  Chat
//
//  Created by Павел Левищев on 18.11.2020.
//  Copyright © 2020 p.levishchev. All rights reserved.
//

import Foundation

class RootAssembly {
    lazy var presentationAssembly: IPresentationAssembly = PresentationAssembly(serviceAssembly: self.serviceAssembly)
    private lazy var serviceAssembly: IServicesAssembly = ServicesAssembly(coreAssembly: coreAssembly)
    private lazy var coreAssembly: ICoreAssembly = CoreAssembly()
}
