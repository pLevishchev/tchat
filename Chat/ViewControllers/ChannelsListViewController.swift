//
//  ChannelsListViewController.swift
//  Chat
//
//  Created by p.levishchev on 26.09.2020.
//  Copyright © 2020 p.levishchev. All rights reserved.
//

import UIKit

class ChannelsListViewController: UIViewController {
    var currentTheme: ThemeModel {
        ThemeManager.shared.currentTheme()
    }
    var channels = [Channel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
        view.addSubview(tableView)
        //        UINavigationBar.appearance().barTintColor = ThemeService.shared.currentTheme().backgroundColor
        FirebaseManager().fetchChannels { channels in
            self.channels = channels
            self.tableView.reloadData()
        }
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
                self.channels.append(channel)
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
}

extension ChannelsListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
  
        return channels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
                as? ChannelCell else {
            return UITableViewCell()
        }

        cell.configure(with: channels[indexPath.row])
        
        return cell
    }

}

extension ChannelsListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ConversationViewController()
        vc.navigationItem.title = channels[indexPath.row].name
        vc.idChannel = channels[indexPath.row].identifier
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
