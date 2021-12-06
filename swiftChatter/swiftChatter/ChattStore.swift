//
//  ChattStore.swift
//  swiftChatter
//
//  Created by sugih on 11/21/20.
//  Copyright © 2020 The Regents of the University of Michigan. All rights reserved.
//
import Foundation
import UIKit
import Alamofire

final class ChattStore: ObservableObject {
    static let shared = ChattStore() // create one instance of the class to be shared
    private init() {}                // and make the constructor private so no other
                                     // instances can be created
    @Published private(set) var chatts = [Chatt]()
    private let nFields = Mirror(reflecting: Chatt()).children.count

    private let serverUrl = "https://mnky-chat.com/api/"
    
    private let tokenHeaders: HTTPHeaders = [
        "Authorization": "Token a23cb7a7efd4981c4a85a0cd6428213b38489c01"
    ]
    
    func createChatt(_ chatt: Chatt, image: UIImage?)  {
        guard let apiUrl = URL(string: serverUrl+"create-chat/") else {
            print("createChatt: Bad URL")
            return
        }
        
        AF.upload(multipartFormData: { mpFD in
                    if let name = chatt.name?.data(using: .utf8) {
                        mpFD.append(name, withName: "name")
                    }
                    if let description = chatt.description?.data(using: .utf8) {
                        mpFD.append(description, withName: "description")
                    }
                    if let lat = chatt.lat?.data(using: .utf8) {
                        mpFD.append(lat, withName: "lat")
                    }
                    if let long = chatt.long?.data(using: .utf8) {
                        mpFD.append(long, withName: "long")
                    }
                    if let radius = chatt.radius?.data(using: .utf8) {
                        mpFD.append(radius, withName: "radius")
                    }
                    if let image = image?.jpegData(compressionQuality: 1.0) {
                        mpFD.append(image, withName: "image", fileName: "chattImage", mimeType: "image/jpeg")
                    }
                }, to: apiUrl, method: .post, headers: tokenHeaders).response { response in
                    switch (response.result) {
                    case .success:
                        print("createChatt: new chat created!")
                    case .failure:
                        print("createChatt: new chat failed")
                    }
                }
    }
    
    func getChatts(_ completion: ((Bool) -> ())?){
        let chatt1 = Chatt(chat_id: "80a97", name: "Music Lovers", description: "Come here to talk everything music", lat: "72.8561644", long: "19.0176147", radius: "2.0338", recent_message_content: "Hey", recent_message_timestamp: "10:53:58.694302", image: nil)
        
        self.chatts.append(chatt1)
        
        let chatt2 = Chatt(chat_id: "a16z8", name: "EECS 441", description: "Mobile Application Dev", lat: "72.8561644", long: "19.0176147", radius: "2.0338", recent_message_content: "Gotta Love EECS 441", recent_message_timestamp: "02:22:58.694302", image: nil)
        
        self.chatts.append(chatt2)
        
        let chatt3 = Chatt(chat_id: "a16z8", name: "EECS 485", description: "Mobile Application Dev", lat: "72.8561644", long: "19.0176147", radius: "2.0338", recent_message_content: "Gotta Love EECS 485", recent_message_timestamp: "02:22:58.694302", image: nil)
        
        self.chatts.append(chatt3)
        
    }
    
    func getMessages(_ completion: ((Bool) -> ())?){
        
        var messages: [Chatt.Message] = []
        
        let mess1 = Chatt.Message(content: "Hey", timeStamp: "10:30")
        let mess2 = Chatt.Message(content: "How's it going?", timeStamp: "10:32")
        let mess3 = Chatt.Message(content: "Happy to be here!", timeStamp: "10:35")
        let mess4 = Chatt.Message(content: "What music do you like?", timeStamp: "10:36")
        let mess5 = Chatt.Message(content: "I love jazz!", timeStamp: "10:38")
        let mess6 = Chatt.Message(content: "All that jazz!", timeStamp: "10:39")
        
        messages.append(mess1)
        messages.append(mess2)
        messages.append(mess3)
        messages.append(mess4)
        messages.append(mess5)
        messages.append(mess6)
        
        self.chatts[0].messages = messages
        
        
    }
    
    
    func withinRange(_ givLat: String,_ givLong: String,_ radius:String,_ testLat: String,_ testLong: String) -> Bool {
        guard let newFloat = Float(radius) else { return false }
        let newRadius = newFloat / 69.0
        if Float(testLat)! <= Float(givLat)! + newRadius && Float(testLat)! >= Float(givLat)! - newRadius {
            if Float(testLong)! <= Float(givLong)! + newRadius && Float(testLong)! >= Float(givLong)! - newRadius{
                return true
            }
        }
        return false
    }
    
    
}
