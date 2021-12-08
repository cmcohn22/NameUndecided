//
//  MessageVC.swift
//  swiftChatter
//
//  Created by Griffin Kaufman on 12/2/21.
//  Copyright © 2021 The Regents of the University of Michigan. All rights reserved.
//

import UIKit

final class MessageVC: UIViewController {
    var chatID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Chat ID \(chatID)")
        // setup refreshControler here later
        // iOS 14 or newer
//        refreshControl?.addAction(UIAction(handler: refreshTimeline), for: UIControl.Event.valueChanged)
//        
//        refreshTimeline(nil)
        
    }

    /*
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        refreshTimeline()
    }*/
    
    // MARK:-
//    private func refreshTimeline(_ sender: UIAction?) {
//        MessageLog.shared.get_messages { success in
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
//
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // how many sections are in table
//        return 1
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // how many rows per section
//        return MessageLog.shared.messages.count
//    }
//
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        // event handler when a cell is tapped
//        //selectedRow = indexPath.row
//        //chatt = chatts[indexPath.row]
//        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
//    }
//
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        // populate a single cell
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MessageTableCell", for: indexPath) as? MessageTableCell else {
//            fatalError("No reusable cell!")
//        }
//
//        let message = MessageLog.shared.messages[indexPath.row]
//        cell.backgroundColor = (indexPath.row % 2 == 0) ? .systemGray5 : .systemGray6
//        cell.firstnameLabel.text = message.first_name
//        cell.lastnameLabel.text = message.last_name
//        cell.contentLabel.text = message.content
//        return cell
//    }
}
