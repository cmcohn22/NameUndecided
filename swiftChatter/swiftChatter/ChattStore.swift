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
        
        AF.upload(multipartFormData: { mpFD in
                    if let name = chatt.name?.data(using: .utf8) {
                        mpFD.append(name, withName: "name")
                    }
                    if let description = chatt.description?.data(using: .utf8) {
                        mpFD.append(description, withName: "description")
                    }
                    if let lat = chatt.lat {
                        mpFD.append("\(lat)".data(using: String.Encoding.utf8)!, withName: "lat")
                    }
                    if let long = chatt.long{
                        mpFD.append("\(long)".data(using: String.Encoding.utf8)!, withName: "long")
                    }
                    if let radius = chatt.radius{
                        mpFD.append("\(radius)".data(using: String.Encoding.utf8)!, withName: "radius")
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
    
    
    
}
