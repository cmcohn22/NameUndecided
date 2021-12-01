//
//  ChatVC.swift
//  swiftChatter
//
//  Created by Griffin Kaufman on 11/30/21.
//  Copyright © 2021 The Regents of the University of Michigan. All rights reserved.
//

import Foundation
import UIKit

struct User {
    var username: String
    var first_name: String
    var last_name: String
    var admin: Bool
}

struct MnkyChat_info {
    var chatID: String?
    var chatName: String?
    var chatDescription: String?
    var timestamp: String?
    var users: [User]?
}
enum typeEnum {
    case file
    case message
}

struct Message {
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
    private var mnkyChat_info: MnkyChat_info = MnkyChat_info()
    //get api/messages
    private var messages: [Message] = [Message]()
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
