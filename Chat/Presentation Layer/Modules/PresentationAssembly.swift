//
//  PresentationAssembly.swift
//  Chat
//
//  Created by Павел Левищев on 18.11.2020.
//  Copyright © 2020 p.levishchev. All rights reserved.
//

import Foundation
import UIKit

protocol IPresentationAssembly {
    func channelsListViewController() -> ChannelsListViewController
    func conversationViewController() -> ConversationViewController
    func profileViewController() -> ProfileViewController
    func themesViewController() -> ThemesViewController
    func imagePickerViewController(pickImageCallback: @escaping (UIImage) -> Void) -> ImagePickerViewController

}

class PresentationAssembly: IPresentationAssembly {
    
    private let serviceAssembly: IServicesAssembly
    
    init(serviceAssembly: IServicesAssembly) {
        self.serviceAssembly = serviceAssembly
    }
    
    func channelsListViewController() -> ChannelsListViewController {
        
        return ChannelsListViewController(serviceAssembly: serviceAssembly, presentationAssembly: self)
    }
    
    func conversationViewController() -> ConversationViewController {
        return ConversationViewController(serviceAssembly: serviceAssembly, presentationAssembly: self)
    }
    
    func profileViewController() -> ProfileViewController {
        return ProfileViewController(serviceAssembly: serviceAssembly, presentationAssembly: self)
    }
    
    func themesViewController() -> ThemesViewController {
        return ThemesViewController(presentationAssembly: self)
    }
    
    func imagePickerViewController(pickImageCallback: @escaping (UIImage) -> Void) -> ImagePickerViewController {

        let vc = ImagePickerViewController(presentationAssembly: self, serviceAssembly: serviceAssembly)
        vc.modalTransitionStyle = .coverVertical
        vc.pickImageCallback = pickImageCallback

        return vc
    }
}
