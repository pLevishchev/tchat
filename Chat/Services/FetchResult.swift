//
//  FetchResult.swift
//  Chat
//
//  Created by p.levishchev on 06.11.2020.
//  Copyright © 2020 p.levishchev. All rights reserved.
//

import Foundation

enum FetchResult<Success, Failure: Error> {
    case success(Success)
    case failure(Failure)
}
