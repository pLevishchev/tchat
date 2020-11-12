//
//  ConversationViewController.swift
//  Chat
//
//  Created by Павел Левищев on 06.10.2020.
//  Copyright © 2020 p.levishchev. All rights reserved.
//

import UIKit
import CoreData

class ConversationViewController: UIViewController {
    
    var sendView = SendMessageView()
    var currentTheme: ThemeModel {
        ThemeManager.shared.currentTheme()
    }
    
    var idChannel: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubviews(tableView, sendView)
        configTableView()
        configSenderView()
        tableView.backgroundColor = currentTheme.backgroundColor
        getDataFromDB()
        notifCentre()
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UINib(nibName: cellID, bundle: nil), forCellReuseIdentifier: cellID)
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .singleLine
        
        return tableView
    }()
    
    private func configTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: sendView.topAnchor)
        ])
    }
    
    private lazy var fetchedResultsController: NSFetchedResultsController<MessageDB> = {
        let context = CoreDataManager.shared.context
        
        let fetchRequest: NSFetchRequest<MessageDB> = MessageDB.fetchRequest()
        let sortByCreated = NSSortDescriptor(key: "created", ascending: true)
        
        fetchRequest.sortDescriptors = [sortByCreated]
        fetchRequest.fetchBatchSize = 32
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                  managedObjectContext: context,
                                                                  sectionNameKeyPath: nil,
                                                                  cacheName: nil)
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
    
    func getDataFromDB() {
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("Unable to fetch channel messages: \(error.localizedDescription)")
        }
        FirebaseManager().fetchMessages(channel: idChannel) {  [weak self] error in
            guard let self = self else { return }
            if let error = error {
                self.presentAlertOnMainThread(title: "Не удалось получить список сообщений",
                                              message: error.localizedDescription,
                                              type: .fail)
            }
            self.goToLastCell()
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
    
    func goToLastCell() {
        DispatchQueue.main.async {
            if let messages = self.fetchedResultsController.fetchedObjects?.count, messages > 0 {
                let indexPath = IndexPath(row: messages - 1, section: 0)
                self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }
        }
    }
    
    private func notifCentre() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey]
            as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    @objc private func send() {
        let uuid = Generator().uuid()
        let message = Message(identifier: idChannel,
                              content: sendView.textField.text,
                              created: Date(),
                              senderId: uuid,
                              senderName: "test")
        FirebaseManager().writeMessage(in: idChannel, message: message)
        DispatchQueue.main.async {
            self.sendView.textField.text = ""
        }
    }
    
    private let cellID = String(describing: MessageCell.self)
}

extension ConversationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? MessageCell else {
            return UITableViewCell()
        }
        
        let message = fetchedResultsController.object(at: indexPath)
        if let message = Message(data: message) {
            cell.configure(with: message)
        }
        
        cell.backgroundColor = currentTheme.leftColor
        cell.name.textColor = currentTheme.fontColor
        cell.message.textColor = currentTheme.fontColor
        cell.date.textColor = currentTheme.fontColor
        
        return cell
    }
}

// MARK: - NSFetchedResultsControllerDelegate

extension ConversationViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .automatic)
            }
        case .update:
            if let indexPath = indexPath {
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        case .move:
            if let indexPath = indexPath, let newIndexPath = newIndexPath {
                tableView.deleteRows(at: [indexPath], with: .automatic)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        @unknown default:
            fatalError()
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
        tableView.endUpdates()
    }
}
