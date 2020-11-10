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
        configSenderView()
        tableView.backgroundColor = currentTheme.backgroundColor
        getDataFromDB()
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: view.frame, style: .plain)
        tableView.register(UINib(nibName: cellID, bundle: nil), forCellReuseIdentifier: cellID)
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .singleLine
        
        return tableView
    }()
    
    private lazy var fetchedResultsController: NSFetchedResultsController<MessageDB> = {
        let context = CoreDataManager.shared.coreDataStack.mainContext
        
        let fetchRequest: NSFetchRequest<MessageDB> = MessageDB.fetchRequest()
        let predicate = NSPredicate(format: "channel.identifier == %@", idChannel)
        let sortByCreated = NSSortDescriptor(key: "created", ascending: true)
        
        fetchRequest.predicate = predicate
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
        let message = Message(identifier: idChannel,
                              content: sendView.textField.text,
                              created: Date(),
                              senderId: uuid,
                              senderName: "test")
        FirebaseManager().writeMessage(in: idChannel, message: message)
        DispatchQueue.main.async {
            self.sendView.textField.text = ""
            //            self.messages.append(message)
            self.tableView.reloadData()
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
    //
    //    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    //        return true
    //    }
}

//extension ConversationViewController: UITableViewDelegate {
//
//    func tableView(_ tableView: UITableView,
//                   commit editingStyle: UITableViewCell.EditingStyle,
//                   forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            messages.remove(at: indexPath.row)
//                        tableView.deleteRows(at: [indexPath], with: .fade)
//        }
//    }
//}

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
        tableView.endUpdates()
    }
}
