//
//  IDownloadImage.swift
//  Chat
//
//  Created by Павел Левищев on 24.11.2020.
//  Copyright © 2020 p.levishchev. All rights reserved.
//

import Foundation
import UIKit

protocol IDownloadImage {
    func downloadImage(from url: String, completed: @escaping(UIImage?) -> Void)
}
