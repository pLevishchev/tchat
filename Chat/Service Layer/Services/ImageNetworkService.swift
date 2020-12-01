//
//  ImageNetworkService.swift
//  Chat
//
//  Created by Павел Левищев on 21.11.2020.
//  Copyright © 2020 p.levishchev. All rights reserved.
//

import Foundation
import UIKit

protocol IImageNetworkService {
    func imagesData(completion: @escaping ([ImageDataModel]?, String?) -> Void)
    func downloadImage(from url: String, completed: @escaping(UIImage?) -> Void)
}

class ImageNetworkService: IImageNetworkService {
    
    let imageRequest: IImagesRequest
    let download: IDownloadImage
    
    init(imageRequest: IImagesRequest, download: IDownloadImage) {
        self.imageRequest = imageRequest
        self.download = download
    }
    
    func imagesData(completion: @escaping ([ImageDataModel]?, String?) -> Void) {
        imageRequest.getImagesData { result in
            switch result {
            case .success(let images):
                completion(images, nil)
            case .failure(let error):
                completion(nil, error.localizedDescription)
            }
        }
    }
    
    func downloadImage(from url: String, completed: @escaping(UIImage?) -> Void) {
        download.downloadImage(from: url) { images in
            completed(images)
        }
    }
}
