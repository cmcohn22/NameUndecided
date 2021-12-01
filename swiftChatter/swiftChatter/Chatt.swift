//
//  Chatt.swift
//  swiftChatter
//
//  Created by sugih on 7/24/20.
//  Copyright © 2020 The Regents of the University of Michigan. All rights reserved.
//

struct Chatt {
    var chat_id: String?
    var name: String?
    var description: String?
    var lat: Double?
    var long: Double?
    var radius: Double?
    var recent_message_content: String?
    var recent_message_timestamp: String?
    @ChattPropWrapper var image: String?
    var require_password: Bool?
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
