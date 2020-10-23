//
//  Logo.swift
//  Chat
//
//  Created by p.levishchev on 21.09.2020.
//  Copyright © 2020 p.levishchev. All rights reserved.
//

import UIKit

class Logo: UIView {
    
    var avatar = UIImageView()
    let logoName = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        addSubviews(avatar, logoName)
        configView()
        configureAvatar()
        configureLogoName()
    }
    
    private func configView() {
        let size: CGFloat = DeviceTypes.isiPhoneSE || DeviceTypes.isiPhone8Zoomed ? 200 : 240
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = #colorLiteral(red: 0.8170854449, green: 0.8160859942, blue: 0, alpha: 1)
        layer.cornerRadius = size / 2
        clipsToBounds = true
        
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: size),
            self.widthAnchor.constraint(equalToConstant: size),
        ])
    }
    
    private func configureAvatar() {
        avatar.translatesAutoresizingMaskIntoConstraints = false
        avatar.clipsToBounds = true
        
        NSLayoutConstraint.activate([
            avatar.topAnchor.constraint(equalTo: self.topAnchor),
            avatar.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            avatar.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            avatar.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            avatar.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            avatar.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    private func configureLogoName() {
        let size: CGFloat = DeviceTypes.isiPhoneSE || DeviceTypes.isiPhone8Zoomed ? 115 : 130
        
        logoName.translatesAutoresizingMaskIntoConstraints = false
        logoName.adjustsFontSizeToFitWidth = true
        logoName.textColor = .black
        logoName.font = UIFont(name:"Roboto", size: 0)
        logoName.font = UIFont.boldSystemFont(ofSize: size)
        logoName.textAlignment = .center
        
        NSLayoutConstraint.activate([
            logoName.topAnchor.constraint(equalTo: self.topAnchor),
            logoName.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            logoName.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            logoName.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            logoName.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            logoName.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
}
