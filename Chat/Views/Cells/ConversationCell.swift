//
//  ConversationCell.swift
//  Chat
//
//  Created by p.levishchev on 26.09.2020.
//  Copyright © 2020 p.levishchev. All rights reserved.
//

import UIKit

class ConversationCell: UITableViewCell {
    
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var date: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        avatar.layer.cornerRadius = avatar.frame.size.height / 2
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func config(with model: ConversationCellModel) {
        //        avatar.image = UIImage(data: model.avatar)
        name.text = model.name
        
        if model.message == nil {
            message.font = UIFont.italicSystemFont(ofSize: 16.0)
            message.text = "No messages yet"
        } else {
            message.text = model.message
        }
        
        if Date().hours(from: model.date) > 24 {
            date.text = Formatter.getDate(from: model.date)
        } else {
            date.text = Formatter.getTime(from: model.date)
        }
        
        if model.hasUnreadMessages {
            message.font = UIFont.boldSystemFont(ofSize: 16.0)
        }
        
        if model.isOnline {
            backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
        }
        
    }
}
