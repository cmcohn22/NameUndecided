//
//  MessageVC.swift
//  swiftChatter
//
//  Created by Griffin Kaufman on 12/2/21.
//  Copyright © 2021 The Regents of the University of Michigan. All rights reserved.
//

import UIKit
import Starscream
struct MessageSocket: Encodable{
    let lat:Double
    let long:Double
    let type:String
    let chat_id:String
    let content:String
    
    init(contents: String){// pass params like a constructor
        self.lat = 0.0
        self.long = 0.0
        self.type = "chat_message"
        self.chat_id = "157ace05"
        self.content = contents
    }
//    "lat": 0.0,
//    "long":0.0,
//    "type": "chat_message",
//    "chat_id": "157ace05",
//    "content": "please work!"
}
//class ConnectionManager{
//    var request = URLRequest(url: URL(string: "ws://127.0.0.1:8000/ws/chat/")!)
//    request.timeoutInterval = 5 // Sets the timeout for the connection
//    request.setValue("0.0", forHTTPHeaderField: "lat")
//    request.setValue("0.0", forHTTPHeaderField: "long")
//    request.setValue("Token 215c7443c83149e5dbff2988509d34c765fcc366", forHTTPHeaderField: "Authorization")
//    let socket = WebSocket(request: request)
//    socket.delegate = self
//    socket.connect()
//}
final class MessageVC: UITableViewController{
    
    
    @IBOutlet weak var MessageContent: UITextField!
    
    
    var socket: WebSocket!
    var isConnected = false
    let server = WebSocketServer()
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
//        var request = URLRequest(url: URL(string: "wss://mnky-chat.com/ws/chat/")!)
//                request.timeoutInterval = 5
//                socket = WebSocket(request: request)
//                socket.delegate = self
        
//        request.setValue("Everything is Awesome!", forHTTPHeaderField: "My-Awesome-Header")
//        var request = URLRequest(url: URL(string: "wss://mnky-chat.com/ws/chat/")!)
//        request.timeoutInterval = 5000 // Sets the timeout for the connection
//        request.setValue("0.0", forHTTPHeaderField: "lat")
//        request.setValue("0.0", forHTTPHeaderField: "long")
//        request.setValue("Token bbd9e8de6701f341cd96302a19b98c29e1d62f54", forHTTPHeaderField: "Authorization")
//        print(request)
//        socket = WebSocket(request: request)
//        socket.delegate = self
//        socket.connect()
//        print("connected")// setup refreshControler here later
        // iOS 14 or newer
        refreshControl?.addAction(UIAction(handler: refreshTimeline), for: UIControl.Event.valueChanged)
        
        refreshTimeline(nil)
        
        
    }
    @IBAction func SendMessage(_ sender: Any) {
                    print("good stuff")
        let jsonObject = MessageSocket.init(contents: MessageContent.text!)
                    let jsonEncoder = JSONEncoder()
                            let jsonData = try! jsonEncoder.encode(jsonObject)
                            let json = String(data: jsonData, encoding: .utf8)!
        
                    print(json)
        StartUpVC.shared.writeText((Any).self, json: json)
//                    socket?.write(string: json)
    }
    /*
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        refreshTimeline()
    }*/
//    func didReceive(event: WebSocketEvent, client: WebSocket) {
//            switch event {
//            case .connected(let headers):
//                isConnected = true
//                print("websocket is connected: \(headers)")
//            case .disconnected(let reason, let code):
//                isConnected = false
//                print("websocket is disconnected: \(reason) with code: \(code)")
//            case .text(let string):
//                print("Received text: \(string)")
//            case .binary(let data):
//                print("Received data: \(data.count)")
//            case .ping(_):
//                break
//            case .pong(_):
//                break
//            case .viabilityChanged(_):
//                break
//            case .reconnectSuggested(_):
//                break
//            case .cancelled:
//                isConnected = false
//            case .error(let error):
//                isConnected = false
//                handleError(error)
//            }
//        }
//    func websocketDidConnect(ws: WebSocket) {
//            print("websocket is connected")
//        }
//        func handleError(_ error: Error?) {
//            if let e = error as? WSError {
//                print("websocket encountered an error: \(e.message)")
//            } else if let e = error {
//                print("websocket encountered an error: \(e.localizedDescription)")
//            } else {
//                print("websocket encountered an error")
//            }
//        }
//        @IBAction func writeText(_ sender: Any) {
//            print("good stuff")
//            let jsonObject = MessageSocket.init()
//            let jsonEncoder = JSONEncoder()
//                    let jsonData = try! jsonEncoder.encode(jsonObject)
//                    let json = String(data: jsonData, encoding: .utf8)!
////            print(jsonEncoder)
////            print(jsonData)
//            print(json)
////            let json = try? JSONSerialization.jsonObject(with: jsonObject, options: [])
////            guard JSONSerialization.isValidJSONObject(jsonObject) else {
////                        print("[WEBSOCKET] Value is not a valid JSON object.\n \(jsonObject)")
////                        return
////                    }
////
////                    do {
////                        let data = try JSONSerialization.data(withJSONObject: jsonObject, options: [])
////                        socket.write(data: data)
////                    } catch let error {
////                        print("[WEBSOCKET] Error serializing JSON:\n\(error)")
////                    }
//
//            socket?.write(string: json)
////           didReceive(event: <#T##WebSocketEvent#>, client: <#T##WebSocket#>)
//
////            let jsonObject: [String: Any] = [
////                "lat": 0.0,
////                "long":0.0,
////                "type": "chat_message",
////                "chat_id": "157ace05",
////                "content": "please work!"
//////                "Authorization": "Token bbd9e8de6701f341cd96302a19b98c29e1d62f54"
//////                ]
////                do {
////                    let jsonData = try JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
////                    // here "jsonData" is the dictionary encoded in JSON data
////
////                    let decoded = try JSONSerialization.jsonObject(with: jsonData, options: [])
////                    // here "decoded" is of type `Any`, decoded from JSON data
////
////                    // you can now cast it with the right type
////                    if let dictFromJSON = decoded as? [String:Any] {
////                        print(dictFromJSON)
////                        print(decoded)
////                        socket.write(data: decoded)
////                        print("Woohooooo!")
////                    }
////                } catch {
////                    print("Bad!")
////                    print(error.localizedDescription)
////                }
//
//        }
//
//        // MARK: Disconnect Action
//
////        @IBAction func disconnect(_ sender: Any) {
////            if isConnected {
////                                socket.disconnect()
////            } else {
////                socket.connect()
////            }
////        }

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
//extension MessageVC: WebSocketDelegate{
   
//    func websocketDidConnect(ws: WebSocket) {
//            print("websocket is connected")
//        }
//        func handleError(_ error: Error?) {
//            if let e = error as? WSError {
//                print("websocket encountered an error: \(e.message)")
//            } else if let e = error {
//                print("websocket encountered an error: \(e.localizedDescription)")
//            } else {
//                print("websocket encountered an error")
//            }
//        }
//        @IBAction func writeText(_ sender: Any) {
//            print("good stuff")
//            let jsonObject = MessageSocket.init()
//            let jsonEncoder = JSONEncoder()
//                    let jsonData = try! jsonEncoder.encode(jsonObject)
//                    let json = String(data: jsonData, encoding: .utf8)!
////            print(jsonEncoder)
////            print(jsonData)
//            print(json)
////            let json = try? JSONSerialization.jsonObject(with: jsonObject, options: [])
////            guard JSONSerialization.isValidJSONObject(jsonObject) else {
////                        print("[WEBSOCKET] Value is not a valid JSON object.\n \(jsonObject)")
////                        return
////                    }
////
////                    do {
////                        let data = try JSONSerialization.data(withJSONObject: jsonObject, options: [])
////                        socket.write(data: data)
////                    } catch let error {
////                        print("[WEBSOCKET] Error serializing JSON:\n\(error)")
////                    }
//
//            socket?.write(string: json)
////           didReceive(event: <#T##WebSocketEvent#>, client: <#T##WebSocket#>)
//
////            let jsonObject: [String: Any] = [
////                "lat": 0.0,
////                "long":0.0,
////                "type": "chat_message",
////                "chat_id": "157ace05",
////                "content": "please work!"
//////                "Authorization": "Token bbd9e8de6701f341cd96302a19b98c29e1d62f54"
//////                ]
////                do {
////                    let jsonData = try JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
////                    // here "jsonData" is the dictionary encoded in JSON data
////
////                    let decoded = try JSONSerialization.jsonObject(with: jsonData, options: [])
////                    // here "decoded" is of type `Any`, decoded from JSON data
////
////                    // you can now cast it with the right type
////                    if let dictFromJSON = decoded as? [String:Any] {
////                        print(dictFromJSON)
////                        print(decoded)
////                        socket.write(data: decoded)
////                        print("Woohooooo!")
////                    }
////                } catch {
////                    print("Bad!")
////                    print(error.localizedDescription)
////                }
//
//        }
//
//        // MARK: Disconnect Action
//
//        @IBAction func disconnect(_ sender: Any) {
//            if isConnected {
//                                socket.disconnect()
//            } else {
//                socket.connect()
//            }
//        }

//}
