////
////  MainVC.swift
////  switChatter
////
////  Created by sugih on 7/23/20.
////  Copyright © 2020 The Regents of the University of Michigan. All rights reserved.
////
//import UIKit
//
//final class ActiveChatsVC: UITableViewController {
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // setup refreshControler here later
//        // iOS 14 or newer
//        refreshControl?.addAction(UIAction(handler: refreshTimeline), for: UIControl.Event.valueChanged)
//        
//        refreshTimeline(nil)
//        
//    }
//
//    /*
//    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
//        refreshTimeline()
//    }*/
//    
//    // MARK:-
//    private func refreshTimeline(_ sender: UIAction?) {
//        ActiveChats.shared.get_active_chats { success in
//            DispatchQueue.main.async {
//                if success {
//                    self.tableView.reloadData()
//                }
//                // stop the refreshing animation upon completion:
//                self.refreshControl?.endRefreshing()
//            }
//        }
//    }
//    
//    // MARK:- TableView handlers
//    
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // how many sections are in table
//        return 1
//    }
//    
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // how many rows per section
//        return ActiveChats.shared.chatts.count
//    }
//    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        // event handler when a cell is tapped
//
//        //selectedRow = indexPath.row
//        //chatt = chatts[indexPath.row]
//        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
//    }
//        
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        // populate a single cell
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChattTableCell", for: indexPath) as? ChattTableCell else {
//            fatalError("No reusable cell!")
//        }
//
//        let chat = ActiveChats.shared.chatts[indexPath.row]
//        cell.backgroundColor = (indexPath.row % 2 == 0) ? .systemGray5 : .systemGray6
//        cell.groupchatnameLabel.text = chat.name
//        cell.messageLabel.text = chat.recent_message_content
//        cell.timestampLabel.text = chat.recent_message_timestamp
//        return cell
//    }
//}
