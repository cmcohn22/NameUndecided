//
//  ChattStore.swift
//  swiftChatter
//
//  Created by bob on 11/21/20.
//  Copyright © 2020 The Regents of the University of Michigan. All rights reserved.
//
import Foundation
import CoreLocation

final class ChatLog: ObservableObject {
    static let shared = ChatLog() // create one instance of the class to be shared
    private init() {}                // and make the constructor private so no other
                                     // instances can be created
    @Published private(set) var chatts = [Chatt]()
    private let nFields = Mirror(reflecting: Chatt()).children.count

    private let serverUrl = "http://127.0.0.1:8000/"
    
    let lat = 0.0
    let long = 0.0
    
    func get_active_chats(_ completion: ((Bool) -> ())?) {
        guard let apiUrl = URL(string: serverUrl+"api/chat-log/?lat=" + String(lat) + "&long=" + String(long)) else {
            print("chat-log: Bad URL")
            return
        }
        
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
                print("chat-log: NETWORKING ERROR")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("chat-log: HTTP STATUS: \(httpStatus.statusCode)")
                return
            }
            
            guard let jsonObj = try? JSONSerialization.jsonObject(with: data) as? [String:Any] else {
                print("chat-log: failed JSON deserialization")
                return
            }
            
            print("HERE")
            print(jsonObj)
            let chattsReceived = jsonObj["chat_log"] as? [Dictionary<String,Any?>] ?? []
            print("teehee")
            print(chattsReceived)
            print(type(of: chattsReceived))
        DispatchQueue.main.async {
            self.chatts = [Chatt]()
            for chattEntry in chattsReceived{
                if chattEntry.count == self.nFields {
                    self.chatts.append(Chatt(name: chattEntry["name"] as? String,
                                             recent_message_timestamp: chattEntry["recent_message_timestamp"] as? String, image: chattEntry["image"] as? String))
                } else {
                    print("chat_log: Received unexpected number of fields: \(chattEntry.count) instead of \(self.nFields).")
                }
            }
        }
            success = true // for completion(success)
        }.resume()
    }
}
