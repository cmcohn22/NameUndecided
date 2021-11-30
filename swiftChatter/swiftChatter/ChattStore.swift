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

    func getChatts(_ completion: ((Bool) -> ())?) {
        guard let apiUrl = URL(string: serverUrl+"getaudio/") else {
            print("getChatts: Bad URL")
            return
        }
        
        var request = URLRequest(url: apiUrl)
        request.httpMethod = "GET"

        URLSession.shared.dataTask(with: request) { data, response, error in
            var success = false
            defer { completion?(success) }
            
            guard let data = data, error == nil else {
                print("getChatts: NETWORKING ERROR")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("getChatts: HTTP STATUS: \(httpStatus.statusCode)")
                return
            }
            
            guard let jsonObj = try? JSONSerialization.jsonObject(with: data) as? [String:Any] else {
                print("getChatts: failed JSON deserialization")
                return
            }
            
            let chattsReceived = jsonObj["chatts"] as? [[String?]] ?? []
        DispatchQueue.main.async {
            self.chatts = [Chatt]()
            for chattEntry in chattsReceived {
                if chattEntry.count == self.nFields {
                    self.chatts.append(Chatt(username: chattEntry[0],
                                          message: chattEntry[1],
                                          timestamp: chattEntry[2],
                                          audio: chattEntry[3]))
                } else {
                    print("getChatts: Received unexpected number of fields: \(chattEntry.count) instead of \(self.nFields).")
                }
            }
        }
            success = true // for completion(success)
        }.resume()
    }
    
    func postChatt(_ chatt: Chatt) {
        let jsonObj = ["username": chatt.username,
                       "message": chatt.message,
                       "audio": chatt.audio]
        guard let jsonData = try? JSONSerialization.data(withJSONObject: jsonObj) else {
            print("postChatt: jsonData serialization error")
            return
        }
                
        guard let apiUrl = URL(string: serverUrl+"postaudio/") else {
            print("postChatt: Bad URL")
            return
        }
        
        var request = URLRequest(url: apiUrl)
        request.httpMethod = "POST"
        request.httpBody = jsonData

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let _ = data, error == nil else {
                print("postChatt: NETWORKING ERROR")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("postChatt: HTTP STATUS: \(httpStatus.statusCode)")
                return
            }
        }.resume()
    }
    
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
