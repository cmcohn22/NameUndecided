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
    //@Published private(set) var geofences = [Geofence]()
    
    private let nFields = Mirror(reflecting: Chatt()).children.count
    var chatid : String?
    private let serverUrl = "https://mnky-chat.com/"
    
    let lat = 0.0
    let long = 0.0
    
//    func addGeofence(chatt: Chatt) {
//        let coordinate = CLLocationCoordinate2DMake(0.0, 0.0)//create new CLLocationCoordinate2D with lat and long as params
//        let radius = chatt.radius ?? 0.0 //radius slider
//      let identifier = chatt.chat_id ?? ""//i think this is proper
//      let eventType: Geofence.EventType = .onExit
//      let note = "hey, notification"
//      //added for clarification
//      let geofence = Geofence(
//        coordinate: coordinate,
//        radius: radius,
//        identifier: identifier,
//        note: note,
//        eventType: eventType)
//        //delegate?.addGeofenceViewController(AddGeofenceViewController, didAddGeofence: geofence)
//        print(geofence.radius)
//        print(geofence.identifier)
//        print(geofence)
//        print(type(of: geofence))
//        self.geofences.append(geofence)
//        print(self.geofences[0])
//        //
//      //delegate?.addGeofenceViewController(self, didAddGeofence: geofence)
//    }
    
    func get_active_chats(lat: Double, long: Double, _ completion: ((Bool) -> ())?) {
        guard let apiUrl = URL(string: serverUrl+"api/active-chats/?lat=" + String(lat) + "&long=" + String(long)) else {
            print("active-chats: Bad URL")
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
                   let chatin = Chatt(chat_id: chattEntry["chat_id"] as? String,
                                             name: chattEntry["name"] as? String,
                                             description: chattEntry["description"] as? String,
                                             lat: chattEntry["lat"] as? Double, long: chattEntry["long"] as? Double, radius: chattEntry["radius"] as? Double, recent_message_content: chattEntry["recent_message_content"] as? String, recent_message_timestamp: chattEntry["recent_message_timestamp"] as? String, image: chattEntry["image"] as? String, require_password: chattEntry["require_password"] as? Bool)
                    self.chatts.append(chatin)
                    //self.addGeofence(chatt: chatin)
                    
                    
                } else {
                    print("active-chats: Received unexpected number of fields: \(chattEntry.count) instead of \(self.nFields).")
                }
                //print(self.geofences)
            }
        }
            success = true // for completion(success)
        }.resume()
    }
}
