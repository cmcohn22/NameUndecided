//
//  MessageVC.swift
//  swiftChatter
//
//  Created by Griffin Kaufman on 12/2/21.
//  Copyright © 2021 The Regents of the University of Michigan. All rights reserved.
//

import UIKit
import Starscream
import CoreLocation
struct MessageSocket: Encodable{
    let lat:Double
    let long:Double
    let type:String
    let chat_id:String
    let content:String
    
    init(contents: String, chatID: String, lat: Double, long: Double, type: String){// pass params like a constructor
        self.lat = lat
        self.long = long
        self.type = type
        self.chat_id = chatID
        self.content = contents
    }
}
final class MessageVC: UITableViewController{
    
    lazy var locationManager = CLLocationManager()
   
    @IBOutlet weak var MessageContent: UITextField!
    
    var chat_id : String!
    var socket: WebSocket!
    var isConnected = false
    let server = WebSocketServer()
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(loadList), name: NSNotification.Name(rawValue: "load"), object: nil)

        refreshControl?.addAction(UIAction(handler: refreshTimeline), for: UIControl.Event.valueChanged)
        
        refreshTimeline(nil)
        
        
    }
    @objc func loadList(notification: NSNotification){
        if let dict = notification.userInfo as NSDictionary? {
                   if let mex = dict["message"] as? Message{
                       MessageLog.shared.appendfunc(chatid: chat_id, mezzo: mex)
                       DispatchQueue.main.async {
                               self.tableView.reloadData()
                           // stop the refreshing animation upon completion:
                           self.refreshControl?.endRefreshing()
                       }

                   }
               }
    
    }


    @IBAction func SendMessage(_ sender: Any) {
        guard let currentlocation = locationManager.location else{
                   return
               }
        let dblLat = currentlocation.coordinate.latitude
        let dblLong = currentlocation.coordinate.longitude
        let toke = "Token \(UserStore.shared.activeUser.tokenId!)"
        let tents = MessageContent.text!
        let jsonObject = MessageSocket.init(contents: MessageContent.text!, chatID: chat_id, lat:dblLat, long: dblLong, type: "chat_message")
                    let jsonEncoder = JSONEncoder()
                            let jsonData = try! jsonEncoder.encode(jsonObject)
                            let json = String(data: jsonData, encoding: .utf8)!
        
        StartUpVC.shared.writeText((Any).self, json: json)
        MessageContent.text = ""
    }
   
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if(segue.identifier == "SpecificChatSegue"){
            //TODO
        }
        if let secondVC = segue.destination as? ChatUsersVC,
           let chatDex = tableView.indexPathForSelectedRow?.row
        {
            secondVC.chat_id =  ActiveChats.shared.chatts[chatDex].chat_id
            secondVC.chat_name =  ActiveChats.shared.chatts[chatDex].name
            secondVC.chat_description =  ActiveChats.shared.chatts[chatDex].description
        }
    }

    // MARK:-
    private func refreshTimeline(_ sender: UIAction?) {
        guard let currentlocation = locationManager.location else{
                   return
               }
        let dblLat = currentlocation.coordinate.latitude
        let dblLong = currentlocation.coordinate.longitude
        let toke = "Token \(UserStore.shared.activeUser.tokenId!)"
        MessageLog.shared.get_messages(token: toke, chat_id: chat_id, lat: dblLat, long: dblLong){ success in
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
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
        
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // populate a single cell
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MessageTableCell", for: indexPath) as? MessageTableCell else {
            print("Interesting")
            fatalError("No reusable cell!")
        }

//        let messagey = MessageLog.shared.messages[indexPath.row]
//        let mesdic = socketInfo.shared.messagesDict
//        let testy = indexPath.row
//        let county = socketInfo.shared.messagesDict[self.chat_id]?.count  ?? 0
//        let ubermessage = socketInfo.shared.messagesDict[self.chat_id]?[county - 1]
        let message = socketInfo.shared.messagesDict[self.chat_id]?[indexPath.row]
        cell.backgroundColor = (indexPath.row % 2 == 0) ? .systemGray5 : .systemGray6
        cell.firstnameLabel.text = message?.first_name
        cell.lastnameLabel.text = message?.last_name
        cell.contentLabel.text = message?.content
        return cell
    }
}
