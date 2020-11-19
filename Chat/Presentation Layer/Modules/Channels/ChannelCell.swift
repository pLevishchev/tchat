//
//  ConversationCell.swift
//  Chat
//
//  Created by p.levishchev on 26.09.2020.
//  Copyright © 2020 p.levishchev. All rights reserved.
//

import UIKit

class ChannelCell: UITableViewCell, ConfigurableView {
    typealias ConfigurationModel = Channel
    
    var currentTheme: ThemeModel {
        ThemeManager.shared.currentTheme()
    }
    
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var date: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(with model: ConfigurationModel) {
        name.text = model.name
        message.numberOfLines = 3
        
        if model.lastMessage == nil {
            message.font = UIFont.italicSystemFont(ofSize: 16.0)
            message.text = "No messages yet"
        } else {
            message.font = UIFont.systemFont(ofSize: 16.0)
            message.text = model.lastMessage
        }

        if let lastActivity = model.lastActivity {
            if Date().hours(from: lastActivity) > 24 {
                date.text = Formatter.getDate(from: lastActivity)
            } else {
                date.text = Formatter.getTime(from: lastActivity)
            }
        }
    }
}
