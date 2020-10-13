//
//  ConversationViewController.swift
//  Chat
//
//  Created by Павел Левищев on 06.10.2020.
//  Copyright © 2020 p.levishchev. All rights reserved.
//

import UIKit

class ConversationViewController: UIViewController {
        
    var currentTheme: ThemeModel {
        ThemeService.shared.currentTheme()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: view.frame, style: .plain)
        tableView.register(UINib(nibName: cellID, bundle: nil), forCellReuseIdentifier: cellID)
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        
        return tableView
    }()
    
    private let cellID = String(describing: MessageCell.self)
    
    let messages = [MessageCellModel(text: """
                        Передайте это Гарри Поттеру
                        Если вдруг его встретите
                        Гарри, привет, как дела, приятель
                        Надеюсь, что ты там ещё не спятил
                        Низкий поклон тебе от всей нашей братии
                        С этих глухих болот
                        Нас окружают сплошные маглы
                        И рожи у них такие злые и наглые
                        А ты, как всегда, торчишь в своей Англии
                        На остальное задвинув болт
                        Гарри, скорей прилетай, ты нужен
                        А то нерушимый совсем разрушен
                        Из всех проплешин, из всех проушин
                        Они выкачивают нефть и газ
                        По воле Бога и согласно плану
                        Скоро нас всех поведут на плаху
                        Ты захвати волшебную палку
                        Чтобы двинуть им между глаз
                        Гарри, всё это не очень нормально
                        Жизнь, как качели - то вира, то майна
                        Так что дружище, биткоины майня
                        Не забывай про нас
                        Не забывай, и почувствуй, волшебник
                        То, как на шею давит ошейник
                        Не забывай нас - ты слышишь
""", isMyMessage: true),
                    MessageCellModel(text: "Привет-Привет-Привет Привет-Привет-Привет Привет-Привет-Привет Привет-Привет-Привет Привет-Привет-Привет Привет-Привет-Привет Привет-Привет-Привет Привет-Привет-Привет Привет-Привет-Привет Привет-Привет-Привет Привет-Привет-ПриветПривет-Привет-ПриветПривет-Привет-ПриветПривет-Привет-ПриветПривет-Привет-ПриветПривет-Привет-ПриветПривет-Привет-ПриветПривет-Привет-ПриветПривет-Привет-ПриветПривет-Привет-Привет", isMyMessage: false),
                    MessageCellModel(text: "Привет-Привет-Привет", isMyMessage: true),
                    MessageCellModel(text: "Привет-Привет-Привет", isMyMessage: false),
                    MessageCellModel(text: "Привет-Привет-Привет", isMyMessage: true),
                    MessageCellModel(text: "Привет-Привет-Привет", isMyMessage: false)]
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
        cell.leftLabel.backgroundColor = currentTheme.leftColor
        cell.rightLabel.backgroundColor = currentTheme.rightColor
        
        cell.leftLabel.textColor = currentTheme.fontColor
        cell.rightLabel.textColor = currentTheme.fontColor
        
        cell.backgroundColor = currentTheme.backgroundColor
        
        return cell
    }
}
