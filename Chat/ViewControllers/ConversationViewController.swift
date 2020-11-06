//
//  ConversationViewController.swift
//  Chat
//
//  Created by Павел Левищев on 06.10.2020.
//  Copyright © 2020 p.levishchev. All rights reserved.
//

import UIKit

class ConversationViewController: UIViewController {
    
    var sendView = SendMessageView()
    var currentTheme: ThemeModel {
        ThemeManager.shared.currentTheme()
    }
    var messages = [Message]()
    var idChannel: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubviews(tableView, sendView)
        configSenderView()
        tableView.backgroundColor = currentTheme.backgroundColor
        getDataFromDB()
        tableView.reloadData()
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: view.frame, style: .plain)
        tableView.register(UINib(nibName: cellID, bundle: nil), forCellReuseIdentifier: cellID)
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .singleLine
        
        return tableView
    }()
    
    func getDataFromDB() {
        FirebaseManager().fetchMessages(channel: idChannel) {  [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let messages):
                self.messages = messages
            case .failure(let error):
                self.presentAlertOnMainThread(title: "Не удалось получить список каналов",
                                              message: error.localizedDescription,
                                              type: .fail)            }
        }
    }
    
    private func configSenderView() {
        sendView.translatesAutoresizingMaskIntoConstraints = false
        let tap = UITapGestureRecognizer(target: self, action: #selector(send))
        sendView.sendIt.addGestureRecognizer(tap)
        
        NSLayoutConstraint.activate([
            sendView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            sendView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            sendView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    @objc private func send() {
        let uuid = Generator().uuid()
        let message = Message(identifier: idChannel, content: sendView.textField.text, created: Date(), senderId: uuid, senderName: "test")
        FirebaseManager().writeMessage(in: idChannel, message: message)
        DispatchQueue.main.async {
            self.sendView.textField.text = ""
            self.messages.append(message)
            self.tableView.reloadData()
        }
    }
    
    private let cellID = String(describing: MessageCell.self)
}

extension ConversationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? MessageCell else {
            return UITableViewCell()
        }
        cell.configure(with: messages[indexPath.row])
        
        cell.backgroundColor = currentTheme.leftColor
        cell.name.textColor = currentTheme.fontColor
        cell.message.textColor = currentTheme.fontColor
        cell.date.textColor = currentTheme.fontColor
        
        return cell
    }
}
