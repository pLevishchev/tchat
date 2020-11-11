//
//  ChannelsListViewController.swift
//  Chat
//
//  Created by p.levishchev on 26.09.2020.
//  Copyright © 2020 p.levishchev. All rights reserved.
//

import UIKit
import CoreData

class ChannelsListViewController: UIViewController {
    var currentTheme: ThemeModel {
        ThemeManager.shared.currentTheme()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
        view.addSubview(tableView)
        //        UINavigationBar.appearance().barTintColor = ThemeService.shared.currentTheme().backgroundColor
        getDataFromDB()
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barTintColor = currentTheme.backgroundColor
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: currentTheme.fontColor]
    }
    
    func getDataFromDB() {
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("Unable to fetch channel messages: \(error.localizedDescription)")
        }
        FirebaseManager().fetchChannels { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                self.presentAlertOnMainThread(title: "Не удалось получить список каналов",
                                              message: error.localizedDescription,
                                              type: .fail)
            }
        }
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: view.frame, style: .plain)
        tableView.register(UINib(nibName: cellID, bundle: nil), forCellReuseIdentifier: cellID)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 90.00
        
        return tableView
    }()
    
    private let cellID = String(describing: ChannelCell.self)
    
    private func configureNavBar() {
        navigationItem.title = "Channels"
        navigationItem.leftBarButtonItems = [
            UIBarButtonItem(customView: leftBarButton()),
            UIBarButtonItem(customView: createBarButton())
        ]
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBarButton())
    }
    
    private func leftBarButton() -> UIView {
        let image: UIImage = UIImage(named: "settings")!
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        
        let button = UIButton()
        imageView.addSubview(button)
        button.addTarget(self, action: #selector(openSettings), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }
    
    private func createBarButton() -> UIView {
        let image: UIImage = UIImage(named: "create")!
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        
        let button = UIButton()
        imageView.addSubview(button)
        button.addTarget(self, action: #selector(createChannel), for: .touchUpInside)
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
        button.addTarget(self, action: #selector(openProfile), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }
    
    @objc func openProfile() {
        
        let profileVC = ProfileViewController()
        let navController = UINavigationController(rootViewController: profileVC)
        
        present(navController, animated: true, completion: nil)
    }
    
    @objc func openSettings() {
        let settingsVC = ThemesViewController()
        self.navigationController?.pushViewController(settingsVC, animated: true)
    }
    
    @objc func createChannel() {
        DispatchQueue.main.async {
            let ac = UIAlertController(title: "Введите название нового канала", message: nil, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default) { _ in
                guard let textFields = ac.textFields else { return }
                let id = FirebaseManager().generateChannelId()
                let channel = Channel(identifier: id,
                                      name: textFields[0].text ?? "Unknown channel",
                                      lastMessage: nil,
                                      lastActivity: nil)
                FirebaseManager().writeChannel(channel: channel)
                self.tableView.reloadData()
            }
            
            let cancelButton = UIAlertAction(title: "Отмена", style: .default, handler: nil)
            ac.addTextField { (textField) in
                textField.placeholder = "create new channel"
            }
            ac.addAction(okAction)
            ac.addAction(cancelButton)
            self.present(ac, animated: true, completion: nil)
        }
    }
    
    @objc func dissmissVC() {
        dismiss(animated: true, completion: nil)
    }
    
    private lazy var fetchedResultsController: NSFetchedResultsController<ChannelDB> = {
        let context = CoreDataManager.shared.context
        
        let fetchRequest: NSFetchRequest<ChannelDB> = ChannelDB.fetchRequest()
        let sortByCreated = NSSortDescriptor(key: "lastActivity", ascending: false)
        
        fetchRequest.sortDescriptors = [sortByCreated]
        fetchRequest.fetchBatchSize = 32
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                  managedObjectContext: context,
                                                                  sectionNameKeyPath: nil,
                                                                  cacheName: nil)
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
}

extension ChannelsListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return fetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
            as? ChannelCell else {
                return UITableViewCell()
        }
        
        let channel = fetchedResultsController.object(at: indexPath)
        if let channel = Channel(data: channel) {
            cell.configure(with: channel)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}

extension ChannelsListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ConversationViewController()
        vc.navigationItem.title = fetchedResultsController.object(at: indexPath).name
        vc.idChannel = fetchedResultsController.object(at: indexPath).identifier ?? ""
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let channel = fetchedResultsController.object(at: indexPath)
            guard let id = channel.identifier else { return }
            FirebaseManager().deleteChannel(id: id) { (error) in
                if error != nil {
                    DispatchQueue.main.async {
                        self.presentAlertOnMainThread(title: "AHTUNG",
                                                      message: "Что-то пошло не так при удалении канала",
                                                      type: .fail)
                    }
                }
            }
            CoreDataManager.shared.context.delete(channel)
            CoreDataManager.shared.saveContext()
        }
    }
}

// MARK: - NSFetchedResultsControllerDelegate

extension ChannelsListViewController: NSFetchedResultsControllerDelegate {
    
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
