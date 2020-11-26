//
//  ProfileViewController.swift
//  Chat
//
//  Created by p.levishchev on 18.09.2020.
//  Copyright © 2020 p.levishchev. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, ILogger {
    var currentTheme: ThemeModel {
        ThemeManager.shared.currentTheme()
    }
    
    private lazy var logo = Logo()
    private let name = UITextField()
    private let bio = UITextView()
    private let saveButton = CustomButton(title: "Сохранить")
    private let navBar = UINavigationBar()
    private let stackView = UIStackView()
    private var activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
    
    private var isEditingMode = false
    private var isAnimated = false
    
    private lazy var user = serviceAssembly.coreDataService.fetchUser()
    
    // Dependencies
    private let presentationAssembly: IPresentationAssembly
    private let serviceAssembly: IServicesAssembly
    
    init(serviceAssembly: IServicesAssembly, presentationAssembly: IPresentationAssembly) {
        self.presentationAssembly = presentationAssembly
        self.serviceAssembly = serviceAssembly
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        log()
        setUpUI()
    }
    
    @objc func dismissVC() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func startEdit() {
        isEditingMode = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(addAvatar))
        logo.addGestureRecognizer(tap)
        
        logo.layer.borderWidth = 2
        logo.layer.borderColor = UIColor.gray.cgColor
        
        name.isEnabled = isEditingMode
        name.text = ""
        name.placeholder = user.name
        name.layer.cornerRadius = 10
        name.layer.borderWidth = 2
        name.layer.borderColor = UIColor.gray.cgColor
        
        bio.isEditable = isEditingMode
        bio.layer.cornerRadius = 10
        bio.layer.borderWidth = 2
        bio.layer.borderColor = UIColor.gray.cgColor
        
        bio.textColor = .gray
        isAnimated.toggle()
        isAnimated ? saveButton.shake() : saveButton.shakeOff()
        
    }
    
    private func configNavBar() {
        navBar.translatesAutoresizingMaskIntoConstraints = false
        navigationItem.title = "My Profile"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(dismissVC))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Edit",
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(startEdit))
    }
    
    private func configureLogo() {
        if let photo = user.photo {
            logo.avatar.image = photo
        } else {
            logo.logoName.text = user.firstLetterName()
        }
        NSLayoutConstraint.activate([
            logo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logo.topAnchor.constraint(equalTo: navBar.bottomAnchor, constant: 60)
        ])
    }
    
    private func configureNameLabel() {
        let padding: CGFloat = 20
        name.delegate = self
        name.translatesAutoresizingMaskIntoConstraints = false
        name.adjustsFontSizeToFitWidth = true
        name.textColor = .black
        name.font = UIFont.boldSystemFont(ofSize: 25)
        name.textAlignment = .center
        name.text = user.name
        name.addTarget(self, action: #selector(changeButton), for: .editingChanged)
        
        NSLayoutConstraint.activate([
            name.topAnchor.constraint(equalTo: logo.bottomAnchor, constant: 32),
            name.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            name.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            name.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding)
        ])
    }
    
    @objc private func changeButton() {
        saveButton.isEnabled = true
        saveButton.backgroundColor = .white
    }
    
    private func saveData(user: UserModel, executor: SaveDataProtocol) {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        
        saveButton.isEnabled = false
        saveButton.backgroundColor = .systemGray
        
        executor.saveUser(user: user, viewController: self) {
            self.activityIndicator.stopAnimating()
            self.activityIndicator.removeFromSuperview()
            self.bio.isEditable = false
            self.bio.textColor = .black
            self.saveButton.isEnabled = false
            self.saveButton.backgroundColor = .systemGray
            self.presentAlertOnMainThread(title: "Данные сохранены", message: nil, type: .ok)
        }
    }
    
    private func configureBioLabel() {
        let size: CGFloat = DeviceTypes.isiPhoneSE || DeviceTypes.isiPhone8Zoomed ? 80 : 200
        let padding: CGFloat = 20
        bio.delegate = self
        bio.translatesAutoresizingMaskIntoConstraints = false
        bio.textColor = .black
        bio.backgroundColor = view.backgroundColor
        bio.font = UIFont.systemFont(ofSize: 20)
        bio.textAlignment = .center
        bio.text = user.bio
        
        NSLayoutConstraint.activate([
            bio.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 32),
            bio.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bio.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            bio.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            bio.heightAnchor.constraint(equalToConstant: size)
        ])
    }
    
    private func configureStackView() {
        let padding: CGFloat = 10.0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = padding
        stackView.addArrangedSubview(saveButton)
        saveButton.isEnabled = false
        saveButton.backgroundColor = .systemGray
        saveButton.addTarget(self, action: #selector(saveDataByGCD), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30),
            stackView.heightAnchor.constraint(equalToConstant: 50),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding)
        ])
    }
    
    func configactivityIndicator() {
        activityIndicator.center = view.center
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
    
    @objc func saveDataByGCD() {
        switchOffBorders()
        saveData(user: fillModelCurrentData(), executor: serviceAssembly.saveService)
    }
    
    private func switchOffBorders() {
        isEditingMode = false
        name.layer.borderWidth = 0
        logo.layer.borderWidth = 0
        bio.layer.borderWidth = 0
    }
    
    private func setUpUI() {
        view.backgroundColor = currentTheme.leftColor
        view.addSubviews(navBar, logo, name, bio, stackView, activityIndicator)
        activityIndicator.color = .black
        configureLogo()
        configureNameLabel()
        configureBioLabel()
        configureStackView()
        configNavBar()
        configactivityIndicator()
    }
    
    @objc func addAvatar() {
        CameraHandler(serviceAssembly: serviceAssembly,
                      presentationAssembly: presentationAssembly)
            .pickImage(self) { image in
            self.logo.avatar.image = image
            self.logo.logoName.isHidden = true
        }
    }
    
    private func fillModelCurrentData() -> UserModel {
        UserModel(name: name.text ?? "", bio: bio.text, photo: logo.avatar.image)
    }
}

extension ProfileViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return isEditingMode
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if name.text != "" {
            name.layer.borderWidth = 0
            name.placeholder = name.text
        }
        if bio.text != "" {
            bio.layer.borderWidth = 0
        }
        isEditingMode = false
    }
}

extension ProfileViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) { 
        changeButton()
    }
}
