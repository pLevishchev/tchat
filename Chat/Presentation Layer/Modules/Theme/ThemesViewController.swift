//
//  ThemesViewController.swift
//  Chat
//
//  Created by Павел Левищев on 09.10.2020.
//  Copyright © 2020 p.levishchev. All rights reserved.
//

import UIKit

class ThemesViewController: UIViewController {
    
    private var color = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
    private lazy var heightForHeader = view.frame.height / 10
    let themes = [ThemeManager.shared.classic, ThemeManager.shared.day, ThemeManager.shared.night]

    var currentTheme: ThemeModel {
        ThemeManager.shared.currentTheme()
    }
    
    // Dependencies
    private let presentationAssembly: IPresentationAssembly
    
    init(presentationAssembly: IPresentationAssembly) {
        self.presentationAssembly = presentationAssembly
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        navigationItem.title = "Settings"
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: view.frame, style: .plain)
        tableView.register(UINib(nibName: ThemeCell.cellID, bundle: nil), forCellReuseIdentifier: ThemeCell.cellID)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.backgroundColor = currentTheme.backgroundColor
        tableView.alwaysBounceVertical = false
        
        return tableView
    }()
}

extension ThemesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return themes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ThemeCell.cellID, for: indexPath) as? ThemeCell else {
            return UITableViewCell()
        }
        cell.configure(with: themes[indexPath.row])
        cell.backgroundColor = currentTheme.backgroundColor
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return heightForHeader
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        color = themes[indexPath.row].backgroundColor
        tableView.backgroundColor = color
        tableView.visibleCells.forEach { cell in
            cell.backgroundColor = color
        }
//        ThemeManager.shared.didSelectTheme(theme: themes[indexPath.row])
        ThemeManager.shared.callback?(themes[indexPath.row])
        ThemeManager.shared.saveTheme(theme: themes[indexPath.row])
        navigationController?.navigationBar.barTintColor = currentTheme.backgroundColor
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: currentTheme.fontColor]
    }
}

extension ThemesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: heightForHeader))
        
        return headerView
    }
}
