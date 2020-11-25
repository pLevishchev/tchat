//
//  DownloadImage.swift
//  Chat
//
//  Created by Павел Левищев on 24.11.2020.
//  Copyright © 2020 p.levishchev. All rights reserved.
//

import Foundation
import UIKit

class DownloadImage: IDownloadImage {
    
    let cache = NSCache<NSString, UIImage>()

    func downloadImage(from url: String, completed: @escaping(UIImage?) -> Void) {
        
        let cacheKey = NSString(string: url)
        if let image = cache.object(forKey: cacheKey) {
            completed(image)
            return
        }
        
        guard let url = URL(string: url) else {
            completed(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error  in
            guard let self = self,
                  error == nil,
                  let response = response as? HTTPURLResponse,
                  response.statusCode == 200,
                  let data = data,
                  let image = UIImage(data: data) else {
                completed(nil)
                return
            }
            
            self.cache.setObject(image, forKey: cacheKey)
            completed(image)
        }
        task.resume()
    }
}
