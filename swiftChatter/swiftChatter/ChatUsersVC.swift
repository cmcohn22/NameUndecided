//
//  ChatUsersVC.swift
//  swiftChatter
//
//  Created by Griffin Kaufman on 12/8/21.
//  Copyright © 2021 The Regents of the University of Michigan. All rights reserved.
//

import UIKit


final class ChatUsersTableCell: UITableViewCell {

    @IBOutlet weak var fullnameLabel: UILabel!
    @IBOutlet weak var adminLabel: UILabel!

}

final class ChatUsersVC: UITableViewController {
//    static let shared = ChatUsersVC()
    
    var chat_id : String?
    var chat_name : String?
    var chat_description : String?
    
    
    @IBOutlet weak var MnkyChatName: UILabel!
    @IBOutlet weak var MnkyChatDescription: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ChatSettings.shared.get_chat_info(chat_id: ChatSettings.shared.chat_id, chatName: ChatSettings.shared.chat_name, chatDesc: ChatSettings.shared.chat_description) { success in
            DispatchQueue.main.async {
                if success {
                    self.chat_id = ChatSettings.shared.chat_id
                    self.chat_name = ChatSettings.shared.chat_name
                    self.chat_description = ChatSettings.shared.chat_description
                    self.MnkyChatName.text = ChatSettings.shared.chat_name
                    self.MnkyChatDescription.text = ChatSettings.shared.chat_description
                }
            }
        }

        // setup refreshControler here later
        // iOS 14 or newer
        refreshControl?.addAction(UIAction(handler: refreshTimeline), for: UIControl.Event.valueChanged)
        
        refreshTimeline(nil)
        
    }

    /*
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        refreshTimeline()
    }*/
    
    // MARK:-
    private func refreshTimeline(_ sender: UIAction?) {
        self.tableView.reloadData()
        ChatSettings.shared.get_chat_info(chat_id: ChatSettings.shared.chat_id, chatName: ChatSettings.shared.chat_name, chatDesc: ChatSettings.shared.chat_description) { success in
                DispatchQueue.main.async {
                    if success {
                        self.tableView.reloadData()
                    }
                    // stop the refreshing animation upon completion:
                    self.refreshControl?.endRefreshing()
                }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // how many rows per section
        return ChatSettings.shared.chatUsers.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // event handler when a cell is tapped

        //selectedRow = indexPath.row
        //chatt = chatts[indexPath.row]
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
    }
        
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // populate a single cell
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChatUsersTableCell", for: indexPath) as? ChatUsersTableCell else {
            fatalError("No reusable cell!")
        }

        let chatUser = ChatSettings.shared.chatUsers[indexPath.row]
        cell.backgroundColor = (indexPath.row % 2 == 0) ? .systemGray5 : .systemGray6
        cell.fullnameLabel.text = "\(chatUser.first_name) \(chatUser.last_name)"
        if(chatUser.isAdmin) {
            cell.adminLabel.text = "Admin"
        }
        else {
            cell.adminLabel.text = ""
        }
        return cell
    }
    
    
    
}

