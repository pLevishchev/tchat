//
//  ILogger.swift
//  Chat
//
//  Created by p.levishchev on 18.09.2020.
//  Copyright © 2020 p.levishchev. All rights reserved.
//

import Foundation

protocol ILogger {
    func log(from previous: String, to current: String, method: String)
    func log(method: String)
}

extension ILogger {
    func log(from previous: String,
             to current: String,
             method: String = #function) {
        log(text: "Application moved from \(previous) to \(current), method: \(method)")
    }
    
    func log(method: String = #function) {
        log(text: "Was called: \(method)")
    }
    
    func log(text: String) {
        if ProcessInfo.processInfo.environment["shouldLog"] == "YES" {
            print(text)
        }
    }
}
