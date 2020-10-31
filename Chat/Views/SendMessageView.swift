//
//  SendMessageView.swift
//  Chat
//
//  Created by Павел Левищев on 30.10.2020.
//  Copyright © 2020 p.levishchev. All rights reserved.
//

import UIKit

class SendMessageView: UIView {

    let textField = UITextView()
    let sendIt = UIView()
    var callback: ((String) -> Void)?
    
    var currentTheme: ThemeModel {
        ThemeManager.shared.currentTheme()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        addSubviews(textField, sendIt)
        configView()
        configTextField()
        configButton()
    }
    
    private func configView() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = currentTheme.backgroundColor
        
        NSLayoutConstraint.activate([
            self.bottomAnchor.constraint(equalTo: bottomAnchor),
            self.heightAnchor.constraint(equalToConstant: 100.0)
        ])
    }
    
    private func configTextField() {
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .gray
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.cornerRadius = 10
        textField.layer.borderWidth = 2
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.sizeToFit()
        
        NSLayoutConstraint.activate([
            textField.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            textField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            textField.widthAnchor.constraint(equalToConstant: 300),
            textField.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func configButton() {
        sendIt.layer.borderColor = UIColor.black.cgColor
        sendIt.layer.cornerRadius = 10
        sendIt.layer.borderWidth = 2

        let image: UIImage = UIImage(named: "send")!
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        imageView.contentMode = .scaleAspectFit
        imageView.image = image

        sendIt.addSubview(imageView)
        sendIt.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            sendIt.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            sendIt.leadingAnchor.constraint(equalTo: textField.trailingAnchor, constant: 10),
            sendIt.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            sendIt.heightAnchor.constraint(equalToConstant: 40),
            sendIt.widthAnchor.constraint(equalToConstant: 40)
        ])
    }
}
