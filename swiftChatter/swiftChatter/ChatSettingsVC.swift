//
//  ChatSettingsVC.swift
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


final class ChatSettingsVC: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        ChatSettings.shared.get_chat_info { success in
            DispatchQueue.main.async {
                if success {
                    self.tableView.reloadData()
                }
                // stop the refreshing animation upon completion:
                self.refreshControl?.endRefreshing()
            }
        }
    }
    
    // MARK:- TableView handlers
    
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // how many sections are in table
//        return 1
//    }
    
    
    @IBOutlet weak var MnkyChatName: UILabel!
    @IBOutlet weak var MnkyChatDescription: UILabel!
    
    func fill_mnkychat_info() {
        self.MnkyChatName.text = ChatSettings.shared.chat_name
        self.MnkyChatDescription.text = ChatSettings.shared.chat_description
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
