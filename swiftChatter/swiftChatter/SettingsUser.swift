//
//  SettingsUser.swift
//  swiftChatter
//
//  Created by Robert Manning on 12/8/21.
//  Copyright © 2021 The Regents of the University of Michigan. All rights reserved.
//

import Foundation
import CoreLocation

final class SettingsUser: ObservableObject {
    static let shared = SettingsUser() // create one instance of the class to be shared
    private init() {}                // and make the constructor private so no other
                                     // instances can be created
    @Published private(set) var settings: Settings = Settings()
    
    private let nFields = Mirror(reflecting: Settings()).children.count

    private let serverUrl = "https://mnky-chat.com/"
    
    
    
    func get_user_info(_ completion: ((Bool) -> ())?) {
        guard let apiUrl = URL(string: serverUrl+"api/user-info/") else {
            print("user-info: Bad URL")
            return
        }
        
        var request = URLRequest(url: apiUrl)
        request.addValue("Token 1cbd65f958e5e08855e26d660618f8fa4f63b52d", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            var success = false
            defer { completion?(success) }
            
            guard let data = data, error == nil else {
                print("user-info: NETWORKING ERROR")
                print("1")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("user-info: HTTP STATUS: \(httpStatus.statusCode)")
                print("2")
                return
            }
            
            guard let jsonObj = try? JSONSerialization.jsonObject(with: data) as? [String:String] else {
                print("user-info: failed JSON deserialization")
                print("3")
                return
            }
            
            let userInfo = jsonObj
            DispatchQueue.main.async {
                self.settings.firstnameU = userInfo["first_name"]
                self.settings.lastnameU = userInfo["last_name"]
                self.settings.usernameU = userInfo["username"]
                self.settings.emailU = userInfo["email"]
            }
            success = true // for completion(success)
        }.resume()
    }
}

