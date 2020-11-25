//
//  IImagesRequest.swift
//  Chat
//
//  Created by Павел Левищев on 24.11.2020.
//  Copyright © 2020 p.levishchev. All rights reserved.
//

import Foundation

protocol IImagesRequest {
    func getImagesData(completed: @escaping(Result<[ImageDataModel], UrlError>) -> Void)
}
