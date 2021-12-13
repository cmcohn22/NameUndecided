//
//  ChatSettings.swift
//  swiftChatter
//
//  Created by Pratik Danu on 12/7/21.
//  Copyright © 2021 The Regents of the University of Michigan. All rights reserved.
//

import Foundation
import CoreLocation
import Alamofire

struct ChatUser {
    var username: String?
//    var password: String?
    var first_name: String?
    var last_name: String?
    @UserPropWrapper var profile_pic: String?
    var isAdmin: Bool!
}


final class ChatSettings: ObservableObject {
    static let shared = ChatSettings()
    private init() {}
    
    @Published private(set) var chatUsers = [ChatUser]()
    private let nFields = Mirror(reflecting: ChatUser()).children.count
    
    private let serverUrl = "https://mnky-chat.com/"
    
    var chat_name : String!
    var chat_description : String!
    var image : String!
    private let tokenHeaders: HTTPHeaders = [
        "Authorization": "Token \(UserStore.shared.activeUser.tokenId!)"
    ]
    
    // Retrieve chat info to populate chatUser table cells
    func get_chat_info(chat_id: String, _ completion: ((Bool) -> ())?) {
        guard let apiUrl = URL(string: serverUrl+"api/chat-info/?chat_id=" + String(chat_id)) else {
            print("chat-info: Bad URL")
            return
        }

        var request = URLRequest(url: apiUrl)
        request.httpMethod = "GET"
        request.addValue("Token \(UserStore.shared.activeUser.tokenId!)", forHTTPHeaderField: "Authorization")

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
            self.chat_name = (jsonObj["name"] as! String)
            self.chat_description = (jsonObj["description"] as! String)
            self.image = (jsonObj["image"] as! String)
            let chatUserInfoReceived = jsonObj["users"] as? [Dictionary<String,Any?>] ?? []
//            print(chatUserInfoReceived)
//            print(type(of: chatUserInfoReceived))
            DispatchQueue.main.async {
                self.chatUsers = [ChatUser]()
                for userInfo in chatUserInfoReceived{
                    if userInfo.count == self.nFields {
                        let user = ChatUser(username: userInfo["username"] as? String,
                                                 first_name: userInfo["first_name"] as? String,
                                                 last_name: userInfo["last_name"] as? String,
                                                 profile_pic: userInfo["profile_pic"] as? String,
                                                 isAdmin: userInfo["admin"] as? Bool)
                        self.chatUsers.append(user)
                    } else {
                        print("chat-info: Received unexpected number of fields: \(chatUserInfoReceived.count) instead of \(self.nFields).")
                    }
                }
            }
            success = true // for completion(success)
        }.resume()
    }
    
    func leave_chat(chat_ident: String){
        guard let apiUrl = URL(string: serverUrl+"api/leave-chat/?chat_id=" + String(chat_ident)) else {
            print("signup: Bad URL")
            return
        }
        print("------------")
        print(apiUrl)
        AF.request(apiUrl, method: .post, headers: tokenHeaders).responseJSON { (response) in
                print(response.result)

                switch response.result {

                case .success(_):
                        if(response.response?.statusCode == 200){
                            print("sucessfully left chat")
                        }
                        else{
                            print("did not leave chat")
                        }
                    break
                case .failure(let error):
                    print("did not leave chat")

                    break
                }
            }
    }
        
        func changeChatImg(chat_id: String, imageIn: UIImage?){
            guard let apiUrl = URL(string: "https://mnky-chat.com/api/chat-image/") else {
                print("signup: Bad URL")
                return
            }
            AF.upload(multipartFormData: { mpFD in
                if let image = imageIn?.jpegData(compressionQuality: 1.0) {
                            mpFD.append(image, withName: "profile_pic", fileName: "proPic", mimeType: "image/jpeg")
                        }
            }, to: apiUrl, method: .post, headers: tokenHeaders).responseJSON{ (response) in
                print(response)
            }
        }
    
    
}
