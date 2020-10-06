//
//  ConversationsListViewController.swift
//  Chat
//
//  Created by p.levishchev on 26.09.2020.
//  Copyright © 2020 p.levishchev. All rights reserved.
//

import UIKit

class ConversationsListViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
        // Do any additional setup after loading the view.
        view.addSubview(tableView)
        
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
                          ConversationCellModel(name: "O", message: "456", date: Formatter.getDate(from: "2020/1/18 20:20"), isOnline: false, hasUnreadMessages: false),
                          ConversationCellModel(name: "P", message: "456", date: Formatter.getDate(from: "2020/1/18 20:20"), isOnline: false, hasUnreadMessages: false),
                          ConversationCellModel(name: "R", message: "456", date: Formatter.getDate(from: "2020/1/18 20:20"), isOnline: false, hasUnreadMessages: false),
                          ConversationCellModel(name: "S", message: "456", date: Formatter.getDate(from: "2020/1/18 20:20"), isOnline: false, hasUnreadMessages: false),
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
        cell.config(with: conversations[indexPath.section][indexPath.row])
        
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
}

enum Sections: String {
    case Online
    case History
}
