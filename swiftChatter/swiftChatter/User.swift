//
//  User.swift
//  swiftChatter
//
//  Created by Mac Pro PD on 11/30/21.
//  Copyright © 2021 The Regents of the University of Michigan. All rights reserved.
//

import Foundation
import SwiftUI

class User {
    var username: String?
    var lat: String?
    var long: String?
    
    func setLat() -> String {
        var locManager = CLLocationManager()
        locManager.requestWhenInUseAuthorization()

        var currentLocation: CLLocation!

        if
           CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
           CLLocationManager.authorizationStatus() ==  .authorizedAlways
        {
            currentLocation = locManager.location
        }
    }
}

