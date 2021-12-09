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
//    var profile_pic:
    var content: String?
    var timestamp: String?
    var profile_pic: String?
    var likes: NSArray?
//    init(messageID:String, firstName: String, lastName: String, userName: String, content: String, timestamp: String, profile_pic: String){
//        self.message_id = messageID
//        self.first_name = firstName
//        self.last_name = lastName
//        self.username = userName
//        self.content = content
//        self.timestamp = timestamp
//        self.profile_pic = profile_pic
//        self.likes = []
//        
//    }
//    var likes: [Dictionary<String,Any?>]? // TODO: Determine Type if we choose to implement
}
