//
//  MainVC.swift
//  switChatter
//
//  Created by sugih on 7/23/20.
//  Copyright © 2020 The Regents of the University of Michigan. All rights reserved.
//
import UIKit
import CoreLocation

final class ChatLogVC: UITableViewController {
    
    lazy var locationManager = CLLocationManager()
    @objc func refresh(sender:AnyObject)
    {
        // Updating your data here...
        refreshTimeline(nil)
        self.tableView.reloadData()
        self.refreshControl?.endRefreshing()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // setup refreshControler here later
        // iOS 14 or newer
        refreshControl?.addAction(UIAction(handler: refreshTimeline), for: UIControl.Event.valueChanged)
        
        locationManager.requestAlwaysAuthorization()
        
        refreshTimeline(nil)
        
    }

    /*
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        refreshTimeline()
    }*/
    
    // MARK:-
    private func refreshTimeline(_ sender: UIAction?) {
        guard let currentlocation = locationManager.location else{
            return
        }
//        print(currentlocation.coordinate.latitude)
//        print(currentlocation.coordinate.longitude)
        ChatLog.shared.get_chat_log(token: UserStore.shared.activeUser.tokenId, lat: currentlocation.coordinate.latitude, long: currentlocation.coordinate.longitude) { success in
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
        return ChatLog.shared.chatts.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // event handler when a cell is tapped

        //selectedRow = indexPath.row
        //chatt = chatts[indexPath.row]
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 80
    }
        
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // populate a single cell
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChatLogTableCell", for: indexPath) as? ChatLogTableCell else {
            fatalError("No reusable cell!")
        }

        let chat = ChatLog.shared.chatts[indexPath.row]
        cell.backgroundColor = (indexPath.row % 2 == 0) ? .systemGray5 : .systemGray6
        cell.groupchatnameLabel.text = chat.name
        //cell.imageLabel = chat.image
        cell.timestampLabel.text = chat.recent_message_timestamp
        return cell
    }
}

