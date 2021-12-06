//
//  User.swift
//  swiftChatter
//
//  Created by Mac Pro PD on 11/30/21.
//  Copyright © 2021 The Regents of the University of Michigan. All rights reserved.
//

import Foundation
import SwiftUI
import CoreLocation

struct User {
    var username: String?
    var password: String?
    var first_name: String?
    var last_name: String?
    var email: String?
    @UserPropWrapper var profile_pic: String?
    var lat: String!
    var long: String!
    
    mutating func setLatLong(_ currentLocation: CLLocation){
        lat = "\(currentLocation.coordinate.latitude)"
        long = "\(currentLocation.coordinate.longitude)"
    }
    
}
@propertyWrapper
struct UserPropWrapper {
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

