//
//  CoreAssembly.swift
//  Chat
//
//  Created by Павел Левищев on 21.11.2020.
//  Copyright © 2020 p.levishchev. All rights reserved.
//

import Foundation

protocol ICoreAssembly {
    var requestSender: IImagesRequest { get }
    var downloadImage: IDownloadImage { get }
}

class CoreAssembly: ICoreAssembly {
    lazy var requestSender: IImagesRequest = ImagesRequest.shared
    lazy var downloadImage: IDownloadImage = DownloadImage()
}
