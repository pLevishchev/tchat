//
//  ThemesViewController.swift
//  Chat
//
//  Created by Павел Левищев on 09.10.2020.
//  Copyright © 2020 p.levishchev. All rights reserved.
//

import UIKit

class ThemesViewController: UIViewController {
    
    private let color = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
    private lazy var heightForHeader = view.frame.height / 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        navigationItem.title = "Settings"
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: view.frame, style: .plain)
        tableView.register(UINib(nibName: cellID, bundle: nil), forCellReuseIdentifier: cellID)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.backgroundColor = color
        tableView.alwaysBounceVertical = false
        
        return tableView
    }()
    
    private let cellID = String(describing: ThemeCell.self)
    
    let themes = [ThemeModel(leftColor: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1), rightColor: #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1), theme: "Classic"),
                  ThemeModel(leftColor: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1), rightColor: #colorLiteral(red: 0, green: 0.3037514985, blue: 0.7640910149, alpha: 1), theme: "Day"),
                  ThemeModel(leftColor: #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1), rightColor: #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1), theme: "Night")]
}

extension ThemesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return themes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? ThemeCell else {
            return UITableViewCell()
        }
        cell.configure(with: themes[indexPath.row])
        cell.backgroundColor = color
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return heightForHeader
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(themes[indexPath.row].theme)
    }
}

extension ThemesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: heightForHeader))
        headerView.backgroundColor = color
        
        return headerView
    }
}
