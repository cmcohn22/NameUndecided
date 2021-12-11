//
//  ChatSettings.swift
//  swiftChatter
//
//  Created by Griffin Kaufman on 12/7/21.
//  Copyright © 2021 The Regents of the University of Michigan. All rights reserved.
//

import Foundation
import CoreLocation

struct ChatUser {
    var username: String?
//    var password: String?
    var first_name: String?
    var last_name: String?
//    var email: String?
    @UserPropWrapper var profile_pic: String?
//    var lat: String!
//    var long: String!
    var isAdmin: Bool!
//    var tokenId: String!
    
//    mutating func setLatLong(_ currentLocation: CLLocation){
//        lat = "\(currentLocation.coordinate.latitude)"
//        long = "\(currentLocation.coordinate.longitude)"
//    }
}

final class ChatSettings: ObservableObject {
    static let shared = ChatSettings()
    private init() {}
    
    @Published private(set) var chatUsers = [ChatUser]()
    private let nFields = Mirror(reflecting: ChatUser()).children.count
    
    private let serverUrl = "https://mnky-chat.com/"
    
    var chat_id : String!
    var chat_name : String!
    var chat_description : String!
    
    // Retrieve chat info to populate chatUser table cells
    func get_chat_info(chat_id: String, chatName: String, chatDesc: String, _ completion: ((Bool) -> ())?) {
        print("THIS FUNCTION IS BEING CALL GETCHATGETCHAT")
        guard let apiUrl = URL(string: serverUrl+"api/chat-info/?chat_id=" + String(chat_id)) else {
            print("chat-info: Bad URL")
            return
        }
        print(apiUrl)
        print("THIS IS OUR URL")

        var request = URLRequest(url: apiUrl)
        request.httpMethod = "GET"
        request.addValue("Token \(UserStore.shared.activeUser.tokenId)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, response, error in
            var success = false
            defer { completion?(success) }

            guard let data = data, error == nil else {
                print("chat-info: NETWORKING ERROR")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("chat-info: HTTP STATUS: \(httpStatus.statusCode)")
                return
            }

            guard let jsonObj = try? JSONSerialization.jsonObject(with: data) as? [String:Any] else {
                print("chat-info: failed JSON deserialization")
                return
            }
            self.chat_id = jsonObj["chat_id"] as! String
            self.chat_name = jsonObj["name"] as! String
            self.chat_description = jsonObj["description"] as! String
            let chatUserInfoReceived = jsonObj["users"] as? [Dictionary<String,Any?>] ?? []
//            print(chatUserInfoReceived)
//            print(type(of: chatUserInfoReceived))
            DispatchQueue.main.async {
                self.chatUsers = [ChatUser]()
                for userInfo in chatUserInfoReceived{
                    if userInfo.count == self.nFields {
                        self.chatUsers.append(ChatUser(username: userInfo["username"] as? String,
                                                 first_name: userInfo["first_name"] as? String,
                                                 last_name: userInfo["last_name"] as? String,
                                                 profile_pic: userInfo["profile_pic"] as? String,
                                                 isAdmin: userInfo["admin"] as? Bool))
                    } else {
                        print("chat-info: Received unexpected number of fields: \(chatUserInfoReceived.count) instead of \(self.nFields).")
                    }
                }
                //print(self.chatUsers)
            }
            success = true // for completion(success)
        }.resume()
    }
}
