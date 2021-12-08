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
struct MessageSocket: Encodable{
    let lat:Double
    let long:Double
    let type:String
    let chat_id:String
    let content:String
    
    init(){// pass params like a constructor
        self.lat = 0.0
        self.long = 0.0
        self.type = "chat_message"
        self.chat_id = "157ace05"
        self.content = "please work!"
    }
}
    class StartUpVC: UIViewController, WebSocketDelegate{
        func handleError(_ error: Error?) {
            if let e = error as? WSError {
                print("websocket encountered an error: \(e.message)")
            } else if let e = error {
                print("websocket encountered an error: \(e.localizedDescription)")
            } else {
                print("websocket encountered an error")
            }
        }
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
        var request = URLRequest(url: URL(string: "wss://mnky-chat.com/ws/chat/")!)
        request.timeoutInterval = 5000 // Sets the timeout for the connection
        request.setValue("0.0", forHTTPHeaderField: "lat")
        request.setValue("0.0", forHTTPHeaderField: "long")
        request.setValue("Token bbd9e8de6701f341cd96302a19b98c29e1d62f54", forHTTPHeaderField: "Authorization")
        print(request)
        socket = WebSocket(request: request)
        socket.delegate = self
        socket.connect()
        print("connected")// setup refreshControler here later
        // iOS 14 or newer
       
       
        func websocketDidConnect(ws: WebSocket) {
                print("websocket is connected")
            }
            
            func writeText(_ sender: Any) {
                print("good stuff")
                let jsonObject = MessageSocket.init()
                let jsonEncoder = JSONEncoder()
                        let jsonData = try! jsonEncoder.encode(jsonObject)
                        let json = String(data: jsonData, encoding: .utf8)!
    //            print(jsonEncoder)
    //            print(jsonData)
                print(json)
    //            let json = try?
                socket?.write(string: json)

                
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
}
