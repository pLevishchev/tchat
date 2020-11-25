//
//  ImagesRequest.swift
//  Chat
//
//  Created by Павел Левищев on 24.11.2020.
//  Copyright © 2020 p.levishchev. All rights reserved.
//

import UIKit
import SwiftyJSON

class ImagesRequest: IImagesRequest {
    
    static let shared = ImagesRequest()
    private var baseUrl: String = "https://pixabay.com/api/"
    private var key: String = "?key=19207193-ad464a009e84305ed2ecc000d"
    private var query = "&q=animals"
    private var pretty = "&pretty=true"
    private var perPage = "&per_page=100"
    
    let cache = NSCache<NSString, UIImage>()
    
    private init() {}
    
    func getImagesData(completed: @escaping(Result<[ImageDataModel], UrlError>) -> Void) {
        let endpoint = baseUrl + key + query + pretty + perPage
        
        guard let url = URL(string: endpoint) else {
            completed(.failure(.invalidParse))
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error {
                completed(.failure(.invalidDataTask))
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidDataTask))
                return
            }
            
            guard let data = data else {
                completed(.failure(.invalidDataTask))
                return
            }
            
            var images = [ImageDataModel]()
            let json = JSON(data)
            guard let hits = json["hits"].array else {
                completed(.failure(.invalidDataTask))
                return
            }
            
            for hit in hits {
                guard let image = hit["largeImageURL"].string else {
                    continue
                }
                images.append(ImageDataModel(largeImageURL: image))
            }
            completed(.success(images))
        }
        task.resume()
    }
}

enum UrlError: String, Error {
    case invalidParse = "Не удалось распарсить"
    case invalidDataTask = "Что-то пошло не так"
}
