//
//  ProfileViewController.swift
//  Chat
//
//  Created by p.levishchev on 18.09.2020.
//  Copyright © 2020 p.levishchev. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, ILogger {
    
    private lazy var logo = Logo(title: user.firstLetters())
    private let name = UILabel()
    private let bio = UILabel()
    private let editButton = CustomButton()
    private let navBar = UINavigationBar()
    
    private var user = User(firstName: "Павел",
                            lastName: "Левищев",
                            bio: "Try to do something interesting")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        log()
        setUpUI()
        print("EditButton frame \(editButton.frame)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        log()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        log()
        // размер пересчитается
        print("EditButton frame \(editButton.frame)")
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        log()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        log()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        log()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        log()
    }
    
    @objc func dismissVC() {
        dismiss(animated: true, completion: nil)
    }
    
    private func configNavBar() {
        navBar.translatesAutoresizingMaskIntoConstraints = false
        navigationItem.title = "My Profile"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(dismissVC))
    }
    
    private func configureLogo() {
        NSLayoutConstraint.activate([
            logo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logo.topAnchor.constraint(equalTo: navBar.bottomAnchor, constant: 60),
        ])
    
        let tap = UITapGestureRecognizer(target: self, action: #selector(addAvatar))
        logo.addGestureRecognizer(tap)
    }
    
    private func configureNameLabel() {
        let padding: CGFloat = 20
        name.translatesAutoresizingMaskIntoConstraints = false
        name.adjustsFontSizeToFitWidth = true
        name.textColor = .black
        name.font = UIFont.boldSystemFont(ofSize: 25)
        name.textAlignment = .center
        name.text = "\(user.firstName) \(user.lastName)"
        
        NSLayoutConstraint.activate([
            name.topAnchor.constraint(equalTo: logo.bottomAnchor, constant: 32),
            name.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            name.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            name.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding)
        ])
    }
    
    private func configureBioLabel() {
        let padding: CGFloat = 20
        bio.translatesAutoresizingMaskIntoConstraints = false
        bio.textColor = .black
        bio.textAlignment = .center
        bio.numberOfLines = 3
        bio.text = user.bio
        
        NSLayoutConstraint.activate([
            bio.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 32),
            bio.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bio.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            bio.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding)
        ])
    }
    
    private func configureEditButton() {
        NSLayoutConstraint.activate([
            editButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            editButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30),
            editButton.heightAnchor.constraint(equalToConstant: 50),
            editButton.widthAnchor.constraint(equalToConstant: 263)
        ])
    }
    
    private func setUpUI() {
        view.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        view.addSubviews(navBar, logo, name, bio, editButton)
        configureLogo()
        configureNameLabel()
        configureBioLabel()
        configureEditButton()
        configNavBar()
    }
    
    @objc func addAvatar() {
        CameraHandler().pickImage(self) { image in
            self.logo.avatar.image = image
            self.logo.logoName.isHidden = true
        }
    }
}
