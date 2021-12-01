//
//  Chatt.swift
//  swiftChatter
//
//  Created by sugih on 7/24/20.
//  Copyright © 2020 The Regents of the University of Michigan. All rights reserved.
//

import UIKit
struct Chatt {
    var chat_id: String?
    var name: String?
    var description: String?
    var lat: String?
    var long: String?
    var radius: String?
    var recent_message_content: String?
    var recent_message_timestamp: String?
    @ChattPropWrapper var image: String?
}

@propertyWrapper
struct ChattPropWrapper {
    private var _value: String?
    var wrappedValue: String? {
        get { _value }
        set {
            guard let newValue = newValue else {
                _value = nil
                return
            }
            _value = (newValue == "null" || newValue.isEmpty) ? nil : newValue
        }
    }
    
    init(wrappedValue: String?) {
        self.wrappedValue = wrappedValue
    }
}

