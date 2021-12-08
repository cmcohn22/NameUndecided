//
//  MessageVC.swift
//  swiftChatter
//
//  Created by Griffin Kaufman on 12/2/21.
//  Copyright © 2021 The Regents of the University of Michigan. All rights reserved.
//

import UIKit
import SocketIO
import CoreLocation

final class MessageVC: UITableViewController {
    var chat_id : String!
    lazy var locationManager = CLLocationManager()
    
    @IBOutlet weak var MessageContent: UITextField!
    @IBAction func SendMessage(_ sender: Any) {
        
    }

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
        //        self.tableView(<#T##UITableView#>, cellForRowAt: <#T##IndexPath#>)
                //let path = sender?.indexPath as? IndexPath
                //guard let cell = sender.indexPathForSelectedRow(at:path) else { return }
        //        let cell = tableView.cellForRow(at: path)
        //        cell.
                //guard let send = sender else { return }
                //guard let cell = sender?.image as? UITableViewCell else { return }
                //guard let cellv = sender?.superview as UITableViewCell else { return }
               // guard let cell = sender?.superview.superview as? ChattTableCell else { return }
                //let chatid = (cellv.chatID)! as String
        print("chatid messages:")
        print(chat_id)
        guard let currentlocation = locationManager.location else{
                   return
               }
               print(currentlocation.coordinate.latitude)
               print(currentlocation.coordinate.longitude)
//               guard let chatid = ActiveChats.shared.chatid else { return }
//        var utoken : String
//        print(LogInVC.shared.userToken)
//        print(SignUpVC.shared.userToken)
//        if((LogInVC.shared.userToken) != nil){
//            utoken = LogInVC.shared.userToken ?? "faillog"
//        print("USERTOKEN LOGIN")
//            print(utoken)
//        } else if ((SignUpVC.shared.userToken) != nil){
//            utoken = SignUpVC.shared.userToken ?? "failsign"
//            print("SignTOKEN LOGIN")
//                print(utoken)
//        }
//        else{
//            utoken = "fail"//"154685558fb3bb2d33ec51dbf5918e76ade92fcb"
//        }
        //print(utoken)
        
        MessageLog.shared.get_messages(token: UserStore.shared.activeUser.tokenId, chat_id: chat_id, lat: currentlocation.coordinate.latitude, long: currentlocation.coordinate.longitude) { success in
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
        
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // populate a single cell
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MessageTableCell", for: indexPath) as? MessageTableCell else {
            print("Interesting")
            fatalError("No reusable cell!")
        }

        let message = MessageLog.shared.messages[indexPath.row]
        cell.backgroundColor = (indexPath.row % 2 == 0) ? .systemGray5 : .systemGray6
        cell.firstnameLabel.text = message.first_name
        cell.lastnameLabel.text = message.last_name
        cell.contentLabel.text = message.content
//        cell.profilePic.
        return cell
    }
}








//
////
////  MessageVC.swift
////  swiftChatter
////
////  Created by Griffin Kaufman on 12/2/21.
////  Copyright © 2021 The Regents of the University of Michigan. All rights reserved.
////
//
//import UIKit
//import CoreLocation
//import Starscream
//
//final class MessageVC: UITableViewController {
//    
//    
//    
//    // MARK: - Properties
//    var request = URLRequest(url: URL(string: "ws://url/ws/chat/")!)
//    lazy var locationManager = CLLocationManager()
//    var didConnect : String = "didConnect"
////    var socket = WebSocket(url: URL(string: "ws://url/ws/chat/"), protocols: ["chat"] as! Engine) //change string
//
//    // MARK: - IBOutlets
//    @IBOutlet var emojiLabel: UILabel!
//    @IBOutlet var usernameLabel: UILabel!
//
//    // MARK: - View Life Cycle
//    override func viewDidLoad() {
//      super.viewDidLoad()
//        request.timeoutInterval = 5
//        var socket = WebSocket(request: request)
//        socket.delegate = self
//        socket.connect()
//      
//
//      navigationItem.hidesBackButton = true
//        
//        refreshControl?.addAction(UIAction(handler: refreshTimeline), for: UIControl.Event.valueChanged)
//        
//        locationManager.requestAlwaysAuthorization()
//        
//        refreshTimeline(nil)
//        
//    }
//
//    deinit {
//      socket.disconnect(forceTimeout: 0)
//      socket.delegate = nil
//        
//    }
//
//
//    /*
//    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
//        refreshTimeline()
//    }*/
//    
//    // MARK:-
//    private func refreshTimeline(_ sender: UIAction?) {
////        self.tableView(<#T##UITableView#>, cellForRowAt: <#T##IndexPath#>)
//        //let path = sender?.indexPath as? IndexPath
//        //guard let cell = sender.indexPathForSelectedRow(at:path) else { return }
////        let cell = tableView.cellForRow(at: path)
////        cell.
//        //guard let send = sender else { return }
//        //guard let cell = sender?.image as? UITableViewCell else { return }
//        //guard let cellv = sender?.superview as UITableViewCell else { return }
//       // guard let cell = sender?.superview.superview as? ChattTableCell else { return }
//        //let chatid = (cellv.chatID)! as String
//        //print(chatid)
//        guard let currentlocation = locationManager.location else{
//            return
//        }
//        print(currentlocation.coordinate.latitude)
//        print(currentlocation.coordinate.longitude)
//        guard let chatid = ActiveChats.shared.chatid else { return }
//        MessageLog.shared.get_messages(chat_id: chatid, lat: currentlocation.coordinate.latitude, long: currentlocation.coordinate.longitude) { success in
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
// 
//        //cell.setValue(value: , forKey: <#T##String#>)
//        return cell
//    }
//}
//
//
//// MARK: - IBActions
//extension MessageVC {
//
//  @IBAction func selectedEmojiUnwind(unwindSegue: UIStoryboardSegue) {
//    guard let viewController = unwindSegue.source as? CollectionViewController,
//      let emoji = viewController.selectedEmoji() else {
//        return
//    }
//
//    sendMessage(emoji)
//  }
//}
//
//// MARK: - FilePrivate
//extension MessageVC {
//
//  fileprivate func sendMessage(_ message: String) {
//      Starscream.socket.write(string: message)
//  }
//
//  fileprivate func messageReceived(_ message: String, senderName: String) {
//    emojiLabel.text = message
//    usernameLabel.text = senderName
//  }
//}
//
//// MARK: - WebSocketDelegate
//extension MessageVC : WebSocketDelegate {
//    func didReceive(event: WebSocketEvent, client: WebSocket) {
//        
//    }
//    
//
//  public func websocketDidConnect(_ socket: Starscream.WebSocket) {
//    socket.write(string: didConnect)
//  }
//
//  public func websocketDidDisconnect(_ socket: Starscream.WebSocket, error: NSError?) {
//    performSegue(withIdentifier: "websocketDisconnected", sender: self)
//  }
//
//  /* Message format:
//   * {"type":"message","data":{"time":1472513071731,"text":"😍","author":"iPhone Simulator","color":"orange"}}
//   */
//  public func websocketDidReceiveMessage(_ socket: Starscream.WebSocket, text: String) {
//    guard let data = text.data(using: .utf16),
//      let jsonData = try? JSONSerialization.jsonObject(with: data),
//      let jsonDict = jsonData as? [String: Any],
//      let messageType = jsonDict["type"] as? String else {
//        return
//    }
//
//    if messageType == "message",
//      let messageData = jsonDict["data"] as? [String: Any],
//      let messageAuthor = messageData["author"] as? String,
//      let messageText = messageData["text"] as? String {
//
//      messageReceived(messageText, senderName: messageAuthor)
//    }
//  }
//
//  public func websocketDidReceiveData(_ socket: Starscream.WebSocket, data: Data) {
//    // Noop - Must implement since it's not optional in the protocol
//  }
//}
