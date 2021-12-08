//
//  MessageVC.swift
//  swiftChatter
//
//  Created by Griffin Kaufman on 12/2/21.
//  Copyright © 2021 The Regents of the University of Michigan. All rights reserved.
//

import UIKit
import SocketIO

final class MessageVC: UITableViewController {
    
    @IBOutlet weak var MessageContent: UITextField!
    @IBAction func SendMessage(_ sender: Any) {
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup refreshControler here later
        // iOS 14 or newer
//        tableView.transform = CGAffineTransform(scaleX: 1, y: -1)
        
        refreshControl?.addAction(UIAction(handler: refreshTimeline), for: UIControl.Event.valueChanged)
        
        refreshTimeline(nil)
        
        
    }

    /*
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        refreshTimeline()
    }*/
    
    // MARK:-
    private func refreshTimeline(_ sender: UIAction?) {
        MessageLog.shared.get_messages { success in
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
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // how many sections are in table
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // how many rows per section
        return MessageLog.shared.messages.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // event handler when a cell is tapped
        //selectedRow = indexPath.row
        //chatt = chatts[indexPath.row]
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       // Make the first row larger to accommodate a custom cell.
//      if indexPath.row == 0 {
//          return 80
//       }

       // Use the default size for all other rows.
//       return UITableView.automaticDimension
        return 80
    }
        
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // populate a single cell
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MessageTableCell", for: indexPath) as? MessageTableCell else {
            print("Interesting")
            fatalError("No reusable cell!")
        }

//        cell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
        
        let message = MessageLog.shared.messages[indexPath.row]
        cell.backgroundColor = (indexPath.row % 2 == 0) ? .systemGray5 : .systemGray6
        cell.firstnameLabel.text = message.first_name
        cell.lastnameLabel.text = message.last_name
        cell.contentLabel.text = message.content
//        cell.profilePic.
        return cell
    }
}
