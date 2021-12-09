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
    //may have to do sometihng funky wi this var
    var count : Int = 0
    private let serverUrl = "https://mnky-chat.com/"
    
    // TODO: Figure out current location
    // TODO: Where am I grabbing chat_id from?
    // warning, make sure I don't append message twice. focus on the refreshing here
    func appendfunc(chatid: String, mezzo: Message){
        MessageLog.shared.messages.append(mezzo)
        socketInfo.shared.messagesDict[chatid, default: []].append(mezzo)
        MessageLog.shared.count = MessageLog.shared.count + 1
    }
    func get_messages(token: String, chat_id: String, lat: Double, long: Double, _ completion: ((Bool) -> ())?) {
        self.messages.removeAll()
        guard let apiUrl = URL(string: serverUrl+"api/messages/?lat=" + String(lat) + "&long=" + String(long) + "&chat_id=" + chat_id) else {
               print("messages: Bad URL")
               return
           }
        print("Get Messages CALLED!!!!!!!!")
        var request = URLRequest(url: apiUrl)
        print(token)
        request.addValue(token, forHTTPHeaderField: "Authorization")
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
            

           // print(jsonObj)
            let messagesReceived = jsonObj["messages"] as? [Dictionary<String,Any?>] ?? []
        DispatchQueue.main.async {
            socketInfo.shared.messagesDict[chat_id, default: []].removeAll()
            MessageLog.shared.messages.removeAll() //POSSIBLY COMMENT OUT
            self.messages = [Message]()
            for message in messagesReceived.reversed(){
                if message.count == self.nFields {
                    let messy = Message(type: message["type"] as? String,
                                                 message_id: message["message_id"] as? String,
                                                 first_name: message["first_name"] as? String,
                                                 last_name: message["last_name"] as? String,
                                                 username: message["username"] as? String,
                                                 content: message["content"] as? String,
                                                 timestamp: message["timestamp"] as? String,
                                                 profile_pic: message["profile_pic"] as? String,
                                                 likes: message["likes"] as? NSArray
                                                 )
                    self.messages.append(messy)
                    //added, messin w socket message struct
                    socketInfo.shared.messagesDict[chat_id, default: []].append(messy)
                    
                } else {
                    print("messages: Received unexpected number of fields: \(message.count) instead of \(self.nFields).")
                }
            }
            //possibly make this shared.count
            MessageLog.shared.count = socketInfo.shared.messagesDict[chat_id, default: []].count
            print("count dict \(self.count)")
            print("MESSAGES after getMESssagescALL!!!")
            print("commented out")
        }
            success = true // for completion(success)
        }.resume()
    }
}
