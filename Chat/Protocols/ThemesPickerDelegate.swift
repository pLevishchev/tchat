//
//  ThemesPickerDelegate.swift
//  Chat
//
//  Created by Павел Левищев on 09.10.2020.
//  Copyright © 2020 p.levishchev. All rights reserved.
//

import Foundation

protocol ThemesPickerDelegate: class {
    func didSelectTheme(theme: ThemeModel)
}
