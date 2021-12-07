//
//  MessageLog.swift
//  swiftChatter
//
//  Created by Griffin Kaufman on 12/2/21.
//  Copyright © 2021 The Regents of the University of Michigan. All rights reserved.
//

import Foundation
import CoreLocation

final class MessageLog: ObservableObject {
    static let shared = MessageLog() // create one instance of the class to be shared
    private init() {}                // and make the constructor private so no other
                                     // instances can be created
    @Published private(set) var messages = [Message]()
    private let nFields = Mirror(reflecting: Message()).children.count

    private let serverUrl = "https://mnky-chat.com/"
    
    // TODO: Figure out current location
    let lat = 0.0
    let long = 0.0
    // TODO: Where am I grabbing chat_id from?
    var chat_id = "157ace05"
    
    func get_messages(_ completion: ((Bool) -> ())?) {
        guard let apiUrl = URL(string: serverUrl+"api/messages/?lat=" + String(lat) + "&long=" + String(long) + "&chat_id=" + chat_id) else {
            print("messages: Bad URL")
            return
        }
        
        var request = URLRequest(url: apiUrl)
        request.addValue("Token bbd9e8de6701f341cd96302a19b98c29e1d62f54", forHTTPHeaderField: "Authorization")
        // TODO: GET RID OF THIS LATER WHEN WE HAVE SIGN UP AND LOGIN WORKING ^
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            var success = false
            defer { completion?(success) }
            
            guard let data = data, error == nil else {
                print("messages: NETWORKING ERROR")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("messages: HTTP STATUS: \(httpStatus.statusCode)")
                return
            }
            
            guard let jsonObj = try? JSONSerialization.jsonObject(with: data) as? [String:Any] else {
                print("messages: failed JSON deserialization")
                return
            }
            

            print(jsonObj)
            let messagesReceived = jsonObj["messages"] as? [Dictionary<String,Any?>] ?? []
            print("messagesReceived: ")
            print(messagesReceived)
            print("end")
            print(type(of: messagesReceived))
        DispatchQueue.main.async {
            self.messages = [Message]()
            for message in messagesReceived{
                if message.count == self.nFields {
                    self.messages.append(Message(type: message["type"] as? String,
                                                 message_id: message["message_id"] as? String,
                                                 first_name: message["first_name"] as? String,
                                                 last_name: message["last_name"] as? String,
                                                 username: message["username"] as? String,
                                                 content: message["content"] as? String,
                                                 timestamp: message["timestamp"] as? String,
                                                 profile_pic: message["profile_pic"] as? String,
                                                 likes: message["likes"] as? NSArray
                                                 ))
                } else {
                    print("messages: Received unexpected number of fields: \(message.count) instead of \(self.nFields).")
                }
            }
        }
            success = true // for completion(success)
        }.resume()
    }
}
