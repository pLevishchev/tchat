//
//  ThemeService.swift
//  Chat
//
//  Created by Павел Левищев on 12.10.2020.
//  Copyright © 2020 p.levishchev. All rights reserved.
//

import Foundation

class ThemeService {
    
    static var shared: ThemeService = {
        let instance = ThemeService()
//        instance.delegat = instance
        instance.callback = { theme in
            instance.theme = theme
        }
        
        return instance
    }()
    
    private init() {}
    
    var userDefaults = UserDefaults.standard
    
    weak var delegat: ThemesPickerDelegate?
    var callback: ((ThemeModel) -> ())?
    
    var classic = ThemeModel(backgroundColor: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1), leftColor: #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1), rightColor: #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1), fontColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), theme: "Classic", onlineColor: #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1), offlineColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
    var day = ThemeModel(backgroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), leftColor: #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1), rightColor: #colorLiteral(red: 0, green: 0.3037514985, blue: 0.7640910149, alpha: 1), fontColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), theme: "Day", onlineColor: #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1), offlineColor: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1))
    var night = ThemeModel(backgroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), leftColor: #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1), rightColor: #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1), fontColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), theme: "Night", onlineColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), offlineColor: #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1))
    
    private var theme: ThemeModel? = nil
    
    func defaultTheme() -> ThemeModel {
        return classic
    }
    
    func currentTheme() -> ThemeModel {
        theme ?? defaultTheme()
    }
}

extension ThemeService: ThemesPickerDelegate {
    func didSelectTheme(theme: ThemeModel) {
        self.theme = theme
    }
}
