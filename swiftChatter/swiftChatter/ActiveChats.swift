//
//  ChattStore.swift
//  swiftChatter
//
//  Created by bob on 11/21/20.
//  Copyright © 2020 The Regents of the University of Michigan. All rights reserved.
//
import Foundation
import CoreLocation

final class ActiveChats: ObservableObject {
    static let shared = ActiveChats() // create one instance of the class to be shared
    private init() {}                // and make the constructor private so no other
                                     // instances can be created
    @Published private(set) var chatts = [Chatt]()
    private let nFields = Mirror(reflecting: Chatt()).children.count

    private let serverUrl = "https://mnky-chat.com/"
    
    func get_active_chats(_ completion: ((Bool) -> ())?) {
        guard let apiUrl = URL(string: serverUrl+"api/active-chats/?lat=\(globalLat)&long=\(globalLong)") else {
            print("active-chats: Bad URL")
            return
        }
        
        print(serverUrl+"api/active-chats/?lat=\(globalLat)&long=\(globalLong)")
        
        var request = URLRequest(url: apiUrl)
        request.httpMethod = "GET"
        
//        let locationManager = CLLocationManager()
//        locationManager.requestAlwaysAuthorization()
//
//        var currentLocation: CLLocation!
//
//        if
//            CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
//            CLLocationManager.authorizationStatus() == .authorizedAlways
//        {
//            currentLocation = locManager.location
//        }
//
//
//        let jsonObj = ["lat": currentLocation.coordinate.longitude,
//                       "long": currentLocation.coordinate.latitude]
//        let jsonObj = ["lat": 0.0, "long": 0.0]
//        guard let jsonData = try? JSONSerialization.data(withJSONObject: jsonObj) else {
//            print("active-chats: jsonData serialization error")
//            return
//        }
//
//        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            var success = false
            defer { completion?(success) }
            
            guard let data = data, error == nil else {
                print("active-chats: NETWORKING ERROR")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("active-chats: HTTP STATUS: \(httpStatus.statusCode)")
                return
            }
            
            guard let jsonObj = try? JSONSerialization.jsonObject(with: data) as? [String:Any] else {
                print("active-chats: failed JSON deserialization")
                return
            }
            
            print("HERE")
            let chattsReceived = jsonObj["active_chats"] as? [Dictionary<String,Any?>] ?? []
            print(chattsReceived)
            print(type(of: chattsReceived))
            print("teehee")
        DispatchQueue.main.async {
            self.chatts = [Chatt]()
            for chattEntry in chattsReceived{
                print("hi")
                if chattEntry.count == self.nFields {
                    self.chatts.append(Chatt(chat_id: chattEntry["chat_id"] as? String,
                                             name: chattEntry["name"] as? String,
                                             description: chattEntry["description"] as? String,
                                             lat: chattEntry["lat"] as? String, long: chattEntry["long"] as? String, radius: chattEntry["radius"] as? String, recent_message_content: chattEntry["recent_message_content"] as? String, recent_message_timestamp: chattEntry["recent_message_timestamp"] as? String, image: chattEntry["image"] as? String, require_password: chattEntry["require_password"] as? Bool))
                } else {
                    print("active-chats: Received unexpected number of fields: \(chattEntry.count) instead of \(self.nFields).")
                }
            }
        }
            success = true // for completion(success)
        }.resume()
    }
}
