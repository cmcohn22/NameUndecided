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
        "Authorization": "Token \(UserStore.shared.activeUser.tokenId!)"
    ]
    
    func createChatt(_ chatt: Chatt, image: UIImage?)  {
        guard let apiUrl = URL(string: serverUrl+"create-chat/") else {
            print("createChatt: Bad URL")
            return
        }
        print("tokenagoisdjfoai")
        print(UserStore.shared.activeUser.tokenId)
        print(UserStore.shared.activeUser.tokenId!)
        
        AF.upload(multipartFormData: { mpFD in
                    if let name = chatt.name?.data(using: .utf8) {
                        mpFD.append(name, withName: "name")
                        print(name)
                    }
                    if let description = chatt.description?.data(using: .utf8) {
                        mpFD.append(description, withName: "description")
                        print(description)
                    }
                    if let lat = chatt.lat {
                        mpFD.append("\(lat)".data(using: String.Encoding.utf8)!, withName: "lat")
                        print(lat)
                    }
                    if let long = chatt.long{
                        mpFD.append("\(long)".data(using: String.Encoding.utf8)!, withName: "long")
                        print(long)
                    }
                    if let radius = chatt.radius{
                        mpFD.append("\(radius)".data(using: String.Encoding.utf8)!, withName: "radius")
                        print(radius)
                    }
                    if let image = image?.jpegData(compressionQuality: 1.0) {
                        mpFD.append(image, withName: "image", fileName: "chattImage", mimeType: "image/jpeg")
                    }
        }, to: apiUrl, method: .post, headers: tokenHeaders).responseJSON(completionHandler: { data in //response in
                    //print(response)
                    print(data)
                    print("anticipated")
//                    {"chat_id":"71193ea5","name":"acmemaf","image":"https://mnky-chat-static.s3.amazonaws.com/media/1873963b-e07a-4800-b18f-13bb9ee094b2.jpeg"}
//                    switch (response.result) {
//                    case .success:
//                        print("createChatt: new chat created!")
//                    case .failure:
//                        print("createChatt: new chat failed")
//                    }
                })
    }
    
    
    
}
