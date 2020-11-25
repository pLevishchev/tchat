//
//  ImagePickerCollectionViewCell.swift
//  Chat
//
//  Created by Павел Левищев on 20.11.2020.
//  Copyright © 2020 p.levishchev. All rights reserved.
//

import UIKit

class ImagePickerCollectionViewCell: UICollectionViewCell {
    static let reuseID = String(describing: ImagePickerCollectionViewCell.self)
    
    @IBOutlet private weak var stackView: UIStackView!
    @IBOutlet private weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .white
        clipsToBounds = true
        layer.cornerRadius = 4
    }
    
    func update(image: UIImage) {
        imageView.image = image
    }
}
