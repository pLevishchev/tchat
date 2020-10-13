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

    @IBOutlet weak var newBackgroundColor: UILabel!
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
        newBackgroundColor.layer.masksToBounds = true
        newBackgroundColor.layer.borderWidth = 1
        newBackgroundColor.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)

        leftLabel.layer.masksToBounds = true
        rightLabel.layer.masksToBounds = true
        
        newBackgroundColor.layer.cornerRadius = 15
        leftLabel.layer.cornerRadius = leftLabel.frame.height / 2
        rightLabel.layer.cornerRadius = leftLabel.frame.height / 2
        leftLabel.layer.borderWidth = 1
        leftLabel.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        rightLabel.layer.borderWidth = 1
        rightLabel.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        newBackgroundColor.backgroundColor = model.backgroundColor
        leftLabel.backgroundColor = model.leftColor
        rightLabel.backgroundColor = model.rightColor
        theme.text = model.theme
        
        if newBackgroundColor.backgroundColor == #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) {
            theme.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            newBackgroundColor.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            leftLabel.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            rightLabel.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
    }
}
