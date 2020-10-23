//
//  ConversationsListViewController.swift
//  Chat
//
//  Created by p.levishchev on 26.09.2020.
//  Copyright © 2020 p.levishchev. All rights reserved.
//

import UIKit

class ConversationsListViewController: UIViewController {
    var currentTheme: ThemeModel {
        ThemeManager.shared.currentTheme()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
        // Do any additional setup after loading the view.
        view.addSubview(tableView)
        //        UINavigationBar.appearance().barTintColor = ThemeService.shared.currentTheme().backgroundColor
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barTintColor = currentTheme.backgroundColor
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: currentTheme.fontColor]
        tableView.reloadData()
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: view.frame, style: .plain)
        tableView.register(UINib(nibName: cellID, bundle: nil), forCellReuseIdentifier: cellID)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 90.00
        
        return tableView
    }()
    
    private let cellID = String(describing: ConversationCell.self)
    
    private func configureNavBar() {
        navigationItem.title = "Chat"
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftBarButton())
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBarButton())
    }
    
    private func leftBarButton() -> UIView {
        let image: UIImage = UIImage(named: "settings")!
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        
        let button = UIButton()
        imageView.addSubview(button)
        button.addTarget(self, action:#selector(openSettings), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }
    
    private func rightBarButton() -> UIView {
        let image: UIImage = UIImage(named: "cat-profile")!
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        
        let button = UIButton()
        imageView.addSubview(button)
        button.addTarget(self, action:#selector(openProfile), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }
    
    @objc func openProfile() {
        
        let profileVC = ProfileViewController()
        let navController = UINavigationController(rootViewController: profileVC)
        
        present(navController, animated:true, completion: nil)
    }
    
    @objc func openSettings() {
        let settingsVC = ThemesViewController()
        self.navigationController?.pushViewController(settingsVC, animated: true)
    }
    
    @objc func dissmissVC() {
        dismiss(animated: true, completion:  nil)
    }
    
    
    let conversations = [[ConversationCellModel(name: "A", message: "123", date: Formatter.getDate(from: "2020/1/18 20:20"), isOnline: true, hasUnreadMessages: false),
                          ConversationCellModel(name: "B", message: "789", date: Formatter.getDate(from: "2020/1/18 20:20"), isOnline: true, hasUnreadMessages: true),
                          ConversationCellModel(name: "C", message: nil, date: Formatter.getDate(from: "2020/1/18 20:20"), isOnline: true, hasUnreadMessages: false),
                          ConversationCellModel(name: "D", message: "789", date: Formatter.getDate(from: "2020/1/18 20:20"), isOnline: true, hasUnreadMessages: true),
                          ConversationCellModel(name: "E", message: "789", date: Formatter.getDate(from: "2020/1/18 20:20"), isOnline: true, hasUnreadMessages: false),
                          ConversationCellModel(name: "F", message: "789", date: Formatter.getDate(from: "2020/1/18 20:20"), isOnline: true, hasUnreadMessages: true),
                          ConversationCellModel(name: "G", message: "789", date: Formatter.getDate(from: "2020/1/18 20:20"), isOnline: true, hasUnreadMessages: true),
                          ConversationCellModel(name: "H", message: nil, date: Formatter.getDate(from: "2020/1/18 20:20"), isOnline: true, hasUnreadMessages: true),
                          ConversationCellModel(name: "I", message: "789", date: Formatter.getDate(from: "2020/1/18 20:20"), isOnline: true, hasUnreadMessages: true),
                          ConversationCellModel(name: "J", message: "789", date: Formatter.getDate(from: "2020/1/18 20:20"), isOnline: true, hasUnreadMessages: true)],
                         [ConversationCellModel(name: "K", message: "456", date: Formatter.getDate(from: "2020/1/18 20:20"), isOnline: false, hasUnreadMessages: true),
                          ConversationCellModel(name: "L", message: "456", date: Formatter.getDate(from: "2020/1/18 20:20"), isOnline: false, hasUnreadMessages: false),
                          ConversationCellModel(name: "M", message: "456", date: Formatter.getDate(from: "2020/1/18 20:20"), isOnline: false, hasUnreadMessages: true),
                          ConversationCellModel(name: "N", message: "456", date: Formatter.getDate(from: "2020/1/18 20:20"), isOnline: false, hasUnreadMessages: false),
                          ConversationCellModel(name: "O", message: nil, date: Formatter.getDate(from: "2020/1/18 20:20"), isOnline: false, hasUnreadMessages: false),
                          ConversationCellModel(name: "P", message: "456", date: Formatter.getDate(from: "2020/1/18 20:20"), isOnline: false, hasUnreadMessages: false),
                          ConversationCellModel(name: "R", message: "456", date: Formatter.getDate(from: "2020/1/18 20:20"), isOnline: false, hasUnreadMessages: false),
                          ConversationCellModel(name: "S", message: nil, date: Formatter.getDate(from: "2020/1/18 20:20"), isOnline: false, hasUnreadMessages: false),
                          ConversationCellModel(name: "T", message: "456", date: Formatter.getDate(from: "2020/1/18 20:20"), isOnline: false, hasUnreadMessages: false),
                          ConversationCellModel(name: "U", message: "456", date: Formatter.getDate(from: "2020/1/18 20:20"), isOnline: false, hasUnreadMessages: false)]
    ]
}

extension ConversationsListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversations[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? ConversationCell else {
            return UITableViewCell()
        }
        cell.configure(with: conversations[indexPath.section][indexPath.row])
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        conversations.count
    }
}

extension ConversationsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return Sections.Online.rawValue
        default:
            return Sections.History.rawValue
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ConversationViewController()
        vc.navigationItem.title = conversations[indexPath.section][indexPath.row].name
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

enum Sections: String {
    case Online
    case History
}
