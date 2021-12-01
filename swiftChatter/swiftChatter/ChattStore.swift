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

    private let serverUrl = "https://18.119.159.133/"
    
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
                }, to: apiUrl, method: .post).response { response in
                    switch (response.result) {
                    case .success:
                        print("createChatt: new chat created!")
                    case .failure:
                        print("createChatt: new chat failed")
                    }
                }
    }
    
    
}
