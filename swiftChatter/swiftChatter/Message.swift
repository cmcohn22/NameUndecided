//
//  Message.swift
//  swiftChatter
//
//  Created by Griffin Kaufman on 12/2/21.
//  Copyright © 2021 The Regents of the University of Michigan. All rights reserved.
//
import UIKit
import Foundation

struct Message {
    var type: String? // if we send attachments or regular messages
    var message_id: String?
    var first_name: String?
    var last_name: String?
    var username: String?
    var content: String?
    var timestamp: String?
    var profile_pic: String?
    var likes: NSArray?

}
