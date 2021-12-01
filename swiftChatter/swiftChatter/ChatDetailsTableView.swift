//
//  ChatVC.swift
//  swiftChatter
//
//  Created by Griffin Kaufman on 11/30/21.
//  Copyright © 2021 The Regents of the University of Michigan. All rights reserved.
//

import Foundation
import UIKit

struct mUser {
    var username: String?
    var first_name: String?
    var last_name: String?
    var admin: Bool?
}

struct MnkyChat_info {
    var chatID: String?
    var chatName: String?
    var chatDescription: String?
    var timestamp: String?
    var users: [mUser?]
}
enum typeEnum {
    case file
    case message
}

struct mMessage {
    var type: typeEnum?
    var message_id: String?
    var first_name: String?
    var last_name: String?
    var username: String?
    var profile_pic: String?
    var content: String?
    //var likes: [User]?
    
}

class ChatDetailsTableView: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    //get api/chat-info, fills out mnkychat_info struct
    private var mnkyChat_info: MnkyChat_info = MnkyChat_info(users : [mUser]())
    //get api/messages
    private var messages: [mMessage] = [mMessage]()
    
    private let nFields =  Mirror(reflecting: Chatt()).children.count
    private let serverUrl = "http://127.0.0.1:8000/"
    
    let chat_id = "5014a329"
    let lat = 0.0
    let long = 0.0
//    mnkyChat_info.chatID = chat_id
    
    // Use GET api/chat_info/
    private func get_info(_ completion: ((Bool) -> ())?) {
        guard let apiUrl = URL(string: serverUrl+"api/chat-info/chat_id=" + String(chat_id)) else {
            print("chat-info: Bad URL")
            return
        }
    
        var request = URLRequest(url: apiUrl)
        request.httpMethod = "GET"
        
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
            
            let chat_info = jsonObj["chat-info"] as? Dictionary<String,Any?> ?? [:]
        DispatchQueue.main.async {
//            messages = []()
            self.mnkyChat_info.chatID = chat_info["chat_id"] as? String
            self.mnkyChat_info.chatName = chat_info["name"] as? String
            self.mnkyChat_info.chatDescription = chat_info["description"] as? String
            self.mnkyChat_info.timestamp = chat_info["timestamp"] as? String
//            self.mnkyChat_info.users = [User]()
            let user_array = chat_info["users"] as? [Dictionary<String,Any?>] ?? []
            for userEntry in user_array{
            //for chatData in chat_info{
                print("hi")
                if userEntry.count == self.nFields {
                    self.mnkyChat_info.users.append(mUser(username: userEntry["username"] as? String,
                                                         first_name: userEntry["first_name"] as? String,
                                                         last_name: userEntry["last_name"] as? String,
                                                         admin: userEntry["admin"] as? Bool))
                } else {
                    print("active-chats: Received unexpected number of fields: \(userEntry.count) instead of \(self.nFields).")
                }
            }
        }
            success = true // for completion(success)
        }.resume()
        
    }
    
    private func get_messages(_ completion: ((Bool) -> ())?) {
        guard let apiUrl = URL(string: serverUrl+"api/messages/?lat=" + String(lat) + "&long=" + String(long) + "chat_id=" + String(chat_id)) else {
            print("message: Bad URL")
            return
        }
    
        var request = URLRequest(url: apiUrl)
        request.httpMethod = "GET"
        
        
    }
    
    
    
    
    private var messageViewModel: MessageViewModel = MessageViewModel()
    var nickName: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configuartionTableView()
        configureViewModel()
    }
    
    private func configuartionTableView() {
        
        self.register(UINib(nibName: "MessageSendTableViewCell", bundle: nil), forCellReuseIdentifier: "MessageSendTableViewCell")
        self.register(UINib(nibName: "MessageTableViewCell", bundle: nil), forCellReuseIdentifier: "MessageTableViewCell")
        
        self.dataSource = self
        self.delegate = self
    }

    private func configureViewModel() {
        
        messageViewModel.arrMessage.subscribe { [weak self] (result: [Message]) in
            
            guard let self = self else {
                return
            }
            
            self.reloadData()
            self.scrollToBottom(animated: false)
        }
        
        messageViewModel.getMessagesFromServer()
    }
}

// MARK: - Table view data source
extension ChatDetailsTableView {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let message: Message = messageViewModel.arrMessage.value[indexPath.row]
        
        if message.nickname == nickName {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MessageSendTableViewCell") as? MessageSendTableViewCell else {
                return UITableView.emptyCell()
            }
            
            cell.configureCell(message)
            return cell
            
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MessageTableViewCell") as? MessageTableViewCell else {
            return UITableView.emptyCell()
        }
        
        cell.configureCell(message)
        return cell
   }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageViewModel.arrMessage.value.count
    }
}
