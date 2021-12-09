//
//  SocketHandler.swift
//  swiftChatter
//
//  Created by Chase Cohn on 12/8/21.
//  Copyright © 2021 The Regents of the University of Michigan. All rights reserved.
//

import Foundation
import UIKit
import Starscream
import CoreLocation

var socket: WebSocket!
var isConnected = false
let server = WebSocketServer()
class socketInfo{

    static let shared = socketInfo()
//    var messagesDict = Dictionary<String, Array<Message>>()
    var messagesDict:[String:[Message]] = [:]
}
    class StartUpVC: UIViewController, WebSocketDelegate{
        lazy var locationManager = CLLocationManager()
        //let f = socketInfo()
        func convertToDictionary(text: String) -> [String: Any]? {
            if let data = text.data(using: .utf8) {
                do {
                    return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                } catch {
                    print(error.localizedDescription)
                }
            }
            return nil
        }
        static let shared = StartUpVC()
        func handleError(_ error: Error?) {
            if let e = error as? WSError {
                print("websocket encountered an error: \(e.message)")
            } else if let e = error {
                print("websocket encountered an error: \(e.localizedDescription)")
            } else {
                print("websocket encountered an error")
            }
        }
//        func onEvent(event: WebSocketEvent){
//            if(event == .text(let string)){
//                
//            }
//        }
        func didReceive(event: WebSocketEvent, client: WebSocket) {
                switch event {
                case .connected(let headers):
                    isConnected = true
                    print("websocket is connected: \(headers)")
                case .disconnected(let reason, let code):
                    isConnected = false
                    print("websocket is disconnected: \(reason) with code: \(code)")
                case .text(let string):
                    print("Received text: \(string)")
                    let message:Dictionary<String,Any?> = convertToDictionary(text: string)!
                    print("now print message!!!I!UI!H")
                    print(message)
                    let chatID:String = message["chat_id"] as! String
                    print("now print message type")
                    print(message["type"])
                    var messager = Message(type: message["type"] as? String,
                                           message_id: message["message_id"] as? String,
                                          first_name: message["first_name"] as? String,
                                          last_name: message["last_name"] as? String,
                                          username: message["username"] as? String,
                                          content: message["content"] as? String,
                                          timestamp: message["timestamp"] as? String,
                                          profile_pic: message["profile_pic"] as? String,
                                           likes: [] as? NSArray
                                          )
                    print("messager yessirrr boy")
                    print(messager)
                    print("messageLog.shared.messages aka this should have all the messages from the get message request")
                    print(MessageLog.shared.messages)
                    print("dict pre add")
                    print(socketInfo.shared.messagesDict)
                    //TODO: This is appending somewhat erratically, make it consistent
                    print("did receive append messager")
                    socketInfo.shared.messagesDict[chatID, default: []].append(messager)
                   //TODO: the following line mighy be bad (messages append)
                    //MessageLog.shared.messages.append(messager)
                    //ERROR: Only Seems to be appending robert manning test message, but when i return and re-call get, the properly sent message shows up
                    //TODO: IMMEADIATELY make call to the table view to return a new cell at the bottom, with appropriate chat info. auto refresh.
                    print("dict post add")
                    print(socketInfo.shared.messagesDict)
                    
                    //TODO: must ponder, how is the table being populated, and what does reloading the data do?
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
                    
//                    let mess = Message.init(messageID: dict["message_id"] as! String, firstName: dict["first_name"] as! String, lastName: dict["last_name"] as! String, userName: dict["username"] as! String, content: dict["content"] as! String, timestamp: dict["timestamp"] as! String, profile_pic: dict["profile_pic"] as! String)
//                    print(mess)
//                    socketInfo.messagesDict["hello"]?.append(mess)
                case .binary(let data):
                    print("Received data: \(data.count)")
                case .ping(_):
                    break
                case .pong(_):
                    break
                case .viabilityChanged(_):
                    break
                case .reconnectSuggested(_):
                    break
                case .cancelled:
                    isConnected = false
                case .error(let error):
                    isConnected = false
                    handleError(error)
                }
            }
        
   
    override func viewDidLoad() {
        //REQUEST LOCATION AND TRY TO DO SOMETING WITH TOKEN ID HERE
        
        super.viewDidLoad()
//        var request = URLRequest(url: URL(string: "wss://mnky-chat.com/ws/chat/")!)
//                request.timeoutInterval = 5
//                socket = WebSocket(request: request)
//                socket.delegate = self
        
//        request.setValue("Everything is Awesome!", forHTTPHeaderField: "My-Awesome-Header")
        var request = URLRequest(url: URL(string: "wss://mnky-chat.com/ws/chat/")!)
        //TODO: Change this ish to like 50
        request.timeoutInterval = 5000 // Sets the timeout for the connection
//        guard let currentlocation = locationManager.location else{
//                   return
//               }
        let dblLat = 0.0 //currentlocation.coordinate.latitude ?? 0.0
        let dblLong = 0.0 //currentlocation.coordinate.longitude ?? 0.0
        request.setValue(String(dblLat), forHTTPHeaderField: "lat")
        request.setValue(String(dblLong), forHTTPHeaderField: "long")
        request.setValue("Token 154685558fb3bb2d33ec51dbf5918e76ade92fcb", forHTTPHeaderField: "Authorization")
        //request.setValue("Token \(UserStore.shared.activeUser.tokenId)", forHTTPHeaderField: "Authorization")
        print(request)
        socket = WebSocket(request: request)
        socket.delegate = self
        socket.connect()
        print("connected")// setup refreshControler here later
        // iOS 14 or newer
    }
       
        func websocketDidConnect(ws: WebSocket) {
                print("websocket is connected")
            }
        func websocketDidDisconnect(ws: WebSocket) {
                print("websocket is Disconnected")
            }
            
        func writeText(_ sender: Any, json: String) {
                print("write text")
          
                print(json)
//            print(socket)
    //            let json = try?
            socket?.write(string: json)
            //TODO: need to see where "socket write" goes. likely have to call a function that updates the shared.messagesDict
            //

                
            }
        func disconnect(_ sender: Any) {
            if isConnected {
                print("disconnected")
                                socket.disconnect()
            } else {
                socket.connect()
            }
        }

        
    }

