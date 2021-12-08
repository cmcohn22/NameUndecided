//
//  MainVC.swift
//  switChatter
//
//  Created by sugih on 7/23/20.
//  Copyright © 2020 The Regents of the University of Michigan. All rights reserved.
//
import UIKit
import CoreLocation

final class ActiveChatsVC: UITableViewController {
    enum PreferencesKeys: String {
      case savedItems
    }
    var geofences: [Geofence] = []
   // var chatidnow : String?
    lazy var locationManager = CLLocationManager()


    override func viewDidLoad() {
        super.viewDidLoad()

        // setup refreshControler here later
        // iOS 14 or newer
        refreshControl?.addAction(UIAction(handler: refreshTimeline), for: UIControl.Event.valueChanged)
        
        //locationManager.delegate = self
        // 2
        locationManager.requestAlwaysAuthorization()
        // 3
        print("viewdidload geofences:")
        print(geofences)
        let currentlocation = locationManager.location
        refreshTimeline(nil)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if(segue.identifier == "SpecificChatSegue"){
            
        }
        if let secondVC = segue.destination as? MessageVC,
           let chatDex = tableView.indexPathForSelectedRow?.row
        {
            secondVC.chat_id =  ActiveChats.shared.chatts[chatDex].chat_id
        //secondVC.image_name = txtEnterText.text
        }
    }

    /*
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        refreshTimeline()
    }*/
    
    // MARK:-
    private func refreshTimeline(_ sender: UIAction?) {
        //for request location "error:  "Delegate must respond to locationManager:didUpdateLocations:"
        //locationManager.requestLocation()
        guard let currentlocation = locationManager.location else{
            return
        }
        print(currentlocation.coordinate.latitude)
        print(currentlocation.coordinate.longitude)
        ActiveChats.shared.get_active_chats(lat: currentlocation.coordinate.latitude, long: currentlocation.coordinate.longitude) { success in
            DispatchQueue.main.async {
                if success {
                    self.geofences = ActiveChats.shared.geofences
                    for geofence in self.geofences{
                                print(geofence.identifier)
                                print(geofence.radius)
                    
                            }
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
        return ActiveChats.shared.chatts.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // event handler when a cell is tapped

        //selectedRow = indexPath.row
        //chatt = chatts[indexPath.row]
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
    }
        
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // populate a single cell
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChattTableCell", for: indexPath) as? ChattTableCell else {
            fatalError("No reusable cell!")
        }

        let chat = ActiveChats.shared.chatts[indexPath.row]
        cell.backgroundColor = (indexPath.row % 2 == 0) ? .systemGray5 : .systemGray6
        cell.groupchatnameLabel.text = chat.name
        cell.messageLabel.text = chat.recent_message_content
        cell.timestampLabel.text = chat.recent_message_timestamp
        cell.chatID = chat.chat_id
        ActiveChats.shared.chatid = chat.chat_id ?? ""
        //cell.init(style: UITableViewCellStyle.subtitle, reuseIdentifier: chat.chat_id)
        return cell
    }

    
}
