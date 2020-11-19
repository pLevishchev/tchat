//
//  Formatter.swift
//  Chat
//
//  Created by p.levishchev on 06.10.2020.
//  Copyright © 2020 p.levishchev. All rights reserved.
//

import Foundation

class Formatter {
    static func getDate(from date: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        guard let date = formatter.date(from: date) else {
            fatalError("Error of date string")
        }
        return date
    }
    
    static func getTime(from date: Date) -> String {
        return getTimeCommon(from: date, dateFormat: "HH:mm")
    }
    
    static func getDate(from date: Date) -> String {
        return getTimeCommon(from: date, dateFormat: "dd/MMM")
    }
    
    // MARK: - Private
    
    static private func getTimeCommon(from date: Date, dateFormat: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MMM"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.string(from: date)
    }
}
