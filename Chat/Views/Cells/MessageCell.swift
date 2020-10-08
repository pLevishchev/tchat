//
//  MessageCellTableViewCell.swift
//  Chat
//
//  Created by Павел Левищев on 07.10.2020.
//  Copyright © 2020 p.levishchev. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell, ConfigurableView {

    typealias ConfigurationModel = MessageCellModel
    
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var rightLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with model: MessageCellModel) {
        leftLabel.numberOfLines = 0
        rightLabel.numberOfLines = 0
        
        leftLabel.lineBreakMode = .byWordWrapping
        rightLabel.lineBreakMode = .byWordWrapping

        
        if model.isMyMessage {
            leftLabel.isHidden = true
            rightLabel.isHidden = false
            
            rightLabel.text = model.text
        } else {
            leftLabel.isHidden = false
            rightLabel.isHidden = true
            
            leftLabel.text = model.text
        }
    }
    
}
