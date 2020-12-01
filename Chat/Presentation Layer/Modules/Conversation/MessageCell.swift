//
//  MessageCellTableViewCell.swift
//  Chat
//
//  Created by Павел Левищев on 07.10.2020.
//  Copyright © 2020 p.levishchev. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell, ConfigurableView {
    typealias ConfigurationModel = Message
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var message: PaddingLabel!
    @IBOutlet weak var date: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(with model: ConfigurationModel) {
        if model.senderId == Generator().uuid() {
            name.text = "It's me"
        } else {
            name.text = model.senderName
        }
        message.text = model.content
        date.text = Formatter.getTime(from: model.created)

        message.numberOfLines = 0
        message.sizeToFit()
        message.lineBreakMode = .byWordWrapping
        message.layer.masksToBounds = true
        message.layer.cornerRadius = 10
//        message.padding(5, 5, 10, 8)
    }
}
