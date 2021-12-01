//
//  Message.swift
//  swiftChatter
//
//  Created by Griffin Kaufman on 12/1/21.
//  Copyright © 2021 The Regents of the University of Michigan. All rights reserved.
//

import Foundation

struct Message: Codable {
    
    var date: String?
    var message: String?
    var nickname: String?
}
