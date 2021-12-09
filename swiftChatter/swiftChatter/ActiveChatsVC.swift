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

    var locationManager = CLLocationManager()
    @IBOutlet weak var toolbar: UIToolbar!

    @objc func refresh(sender:AnyObject)
    {
        // Updating your data here...
        refreshTimeline(nil)
        self.tableView.reloadData()
        self.refreshControl?.endRefreshing()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

           refreshControl?.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl?.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        
        // setup refreshControler here later
        // iOS 14 or newer
        refreshControl?.addAction(UIAction(handler: refreshTimeline), for: UIControl.Event.valueChanged)
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        refreshTimeline(nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if(segue.identifier == "SpecificChatSegue"){
            //TODO
        }
        if let secondVC = segue.destination as? MessageVC,
           let chatDex = tableView.indexPathForSelectedRow?.row
        {
            secondVC.chat_id =  ActiveChats.shared.chatts[chatDex].chat_id
        }
    }

    
    // MARK:-
    private func refreshTimeline(_ sender: UIAction?) {
        guard let currentlocation = locationManager.location else{
            return
        }
        print(currentlocation.coordinate.latitude)
        print(currentlocation.coordinate.longitude)
        ActiveChats.shared.get_active_chats(lat: currentlocation.coordinate.latitude, long: currentlocation.coordinate.longitude) { success in
            DispatchQueue.main.async {
                if success {
                    self.tableView.reloadData()

                }
                // stop the refreshing animation upon completion:
                self.refreshControl?.endRefreshing()
            }
        }
    }
    
  
    
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

// MARK: - Location Manager Delegate
extension ActiveChatsVC: CLLocationManagerDelegate {
  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    let status = manager.authorizationStatus
    }

  func locationManager(
    _ manager: CLLocationManager,
    monitoringDidFailFor region: CLRegion?,
    withError error: Error
  ) {
    guard let region = region else {
      print("Monitoring failed for unknown region")
      return
    }
    print("Monitoring failed for region with identifier: \(region.identifier)")
  }

  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print("Location Manager failed with the following error: \(error)")
  }
    
    func handleEnter(for region: CLRegion) {
        guard let curloc = locationManager.location else{
            return
        }
        ActiveChats.shared.get_active_chats(lat: curloc.coordinate.latitude, long: curloc.coordinate.longitude) { success in
            DispatchQueue.main.async {
                if success {
                    self.tableView.reloadData()
                }
                // stop the refreshing animation upon completion:
                self.refreshControl?.endRefreshing()
            }
        }
    }


    func locationManager(
      _ manager: CLLocationManager,
      didEnterRegion region: CLRegion
    ) {
      if region is CLCircularRegion {
        handleEnter(for: region)
      }
    }

    func locationManager(
      _ manager: CLLocationManager,
      didExitRegion region: CLRegion
    ) {
      if region is CLCircularRegion {
        handleEnter(for: region)
      }
    }
    
}
