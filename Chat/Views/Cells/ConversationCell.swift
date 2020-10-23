//
//  ConversationCell.swift
//  Chat
//
//  Created by p.levishchev on 26.09.2020.
//  Copyright © 2020 p.levishchev. All rights reserved.
//

import UIKit

class ConversationCell: UITableViewCell, ConfigurableView {
    typealias ConfigurationModel = ConversationCellModel
    
    var currentTheme: ThemeModel {
        ThemeManager.shared.currentTheme()
    }
    
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
    
    func configure(with model: ConfigurationModel) {
        //        avatar.image = UIImage(data: model.avatar)
        name.text = model.name
        
        if model.message == nil {
            message.font = UIFont.italicSystemFont(ofSize: 16.0)
            message.text = "No messages yet"
        } else {
            message.font = UIFont.systemFont(ofSize: 16.0)
            message.text = model.message
        }
        
        if Date().hours(from: model.date) > 24 {
            date.text = Formatter.getDate(from: model.date)
        } else {
            date.text = Formatter.getTime(from: model.date)
        }
        
        if model.hasUnreadMessages && model.message != nil {
            message.font = UIFont.boldSystemFont(ofSize: 16.0)
        } else {
            message.font = UIFont.systemFont(ofSize: 16.0)
        }
        
        if model.isOnline {
            backgroundColor = currentTheme.onlineColor
        } else {
            backgroundColor = currentTheme.offlineColor
        }
    }
}
