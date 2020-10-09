//
//  ThemeCell.swift
//  Chat
//
//  Created by Павел Левищев on 09.10.2020.
//  Copyright © 2020 p.levishchev. All rights reserved.
//

import UIKit

class ThemeCell: UITableViewCell, ConfigurableView {
    typealias ConfigurationModel = ThemeModel

    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var rightLabel: UILabel!
    @IBOutlet weak var theme: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with model: ConfigurationModel) {
        leftLabel.layer.masksToBounds = true
        rightLabel.layer.masksToBounds = true
        
        leftLabel.layer.cornerRadius = leftLabel.frame.height / 2
        rightLabel.layer.cornerRadius = leftLabel.frame.height / 2
        
        leftLabel.backgroundColor = model.leftColor
        rightLabel.backgroundColor = model.rightColor
        theme.text = model.theme
    }
}
