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
//    enum PreferencesKeys: String {
//      case savedItems
//    }
    var locationManager = CLLocationManager()
    @IBOutlet weak var toolbar: UIToolbar!

//    self.toolbar.translatesAutoresizingMaskIntoConstraints = false
//    self.view.addSubview(toolbar)
//    
//    //top constraint to toolbar with tableview
//    self.toolbar.topAnchor.constraint(equalTo: tableview.bottomAnchor).isActive = true
//
//    //bottom constraint to toolbar with super view
//    self.view.bottomAnchor.constraint(equalTo: toolbar.bottomAnchor).isActive = true
//
//    //leading constraint to toolbar with super view
//    self.view.leadingAnchor.constraint(equalTo: toolbar.leadingAnchor).isActive = true
//
//    //trailing constraint with toolbar with super view
//    self.view.trailingAnchor.constraint(equalTo: toolbar.trailingAnchor).isActive = true
    // MARK:- TableView handlers
   // var chatidnow : String?
   
    //alazy var refreshControl = UIRefreshControl()
//
//    func startMonitoring(geofence: Geofence) {
//      if !CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
////        showAlert(
////          withTitle: "Error",
////          message: "Geofencing is not supported on this device!")
//        return
//      }
//      let fenceRegion = geofence.region
//      locationManager.startMonitoring(for: fenceRegion)
//    }
//
//    func stopMonitoring(geofence: Geofence) {
//      for region in locationManager.monitoredRegions {
//        guard
//          let circularRegion = region as? CLCircularRegion,
//          circularRegion.identifier == geofence.identifier
//        else { continue }
//
//        locationManager.stopMonitoring(for: circularRegion)
//      }
//    }
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
           //tableView.addSubview(refreshControl?) // not required when using UITableViewController


        // setup refreshControler here later
        // iOS 14 or newer
        refreshControl?.addAction(UIAction(handler: refreshTimeline), for: UIControl.Event.valueChanged)
        
        locationManager.delegate = self
        // 2
        locationManager.requestAlwaysAuthorization()

        // 3
        //self.geofences = ActiveChats.shared.geofences
        //loadAllGeofences()
        print("viewdidload geofences:")
            //print(geofences)
//        let currentlocation = locationManager.location
        refreshTimeline(nil)
        
        
        
    }
//    // MARK: Loading and saving functions
//    func loadAllGeofences() {
//      geofences.removeAll()
//        refreshTimeline(nil)
//      let allGeofences = Geofence.allGeofences()
//        for geofence in allGeofences {
//            add(geofence)
//        }
//     // allGeofences.forEach { add($0) }
//        print("ALL GEO FENCES LOAD ALL:")
//        print(allGeofences)
//        print(geofences)
//    }
//    func add(_ geofence: Geofence) {
//      let curloc = locationManager.location
//      print(curloc?.coordinate.latitude)
//      print(curloc?.coordinate.longitude)
//      geofences.append(geofence)
//      startMonitoring(geofence: geofence)
//      print(geofence.coordinate)
//      //updateGeofencesCount()
//    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if(segue.identifier == "SpecificChatSegue"){
            //TODO
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
//                    self.geofences = ActiveChats.shared.geofences
//                    for geofence in self.geofences{
//                                print(geofence.identifier)
//                                print(geofence.radius)
//
//                            }
                   // self.loadAllGeofences()
                    self.tableView.reloadData()

                }
                // stop the refreshing animation upon completion:
                self.refreshControl?.endRefreshing()
            }
//            for geofence in self.geofences {
//                self.stopMonitoring(geofence: geofence)
//            }
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
    // 1
    let status = manager.authorizationStatus

    // 2
   // mapView.showsUserLocation = (status == .authorizedAlways)

    // 3
//    if status != .authorizedAlways {
//      let message = """
//      Your geofence is saved but will only be activated once you grant
//      Geotify permission to access the device location.
//      """
      //showAlert(withTitle: "Warning", message: message)
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
//                    self.geofences = ActiveChats.shared.geofences
//                    for geofence in self.geofences{
//                                print(geofence.identifier)
//                                print(geofence.radius)
//
//                            }
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
