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

final class UserStore: ObservableObject {
    static let shared = UserStore() // create one instance of the class to be shared
    private init() {}                // and make the constructor private so no other
                                     // instances can be created
    @Published private(set) var chatts = [User]()
    private let nFields = Mirror(reflecting: User()).children.count

    private let serverUrl = "https://18.119.159.133/"
    
    func createUser(_ user: User, image: UIImage?)  {
        guard let apiUrl = URL(string: serverUrl+"signup/") else {
            print("createUser: Bad URL")
            return
        }
        
        AF.upload(multipartFormData: { mpFD in
                    if let username = user.username?.data(using: .utf8) {
                        mpFD.append(username, withName: "username")
                    }
                    if let password = user.password?.data(using: .utf8) {
                        mpFD.append(password, withName: "password")
                    }
                    if let first_name = user.first_name?.data(using: .utf8) {
                        mpFD.append(first_name, withName: "first_name")
                    }
                    if let last_name = user.last_name?.data(using: .utf8) {
                        mpFD.append(last_name, withName: "last_name")
                    }
                    if let email = user.email?.data(using: .utf8) {
                        mpFD.append(email, withName: "email")
                    }
                    if let image = image?.jpegData(compressionQuality: 1.0) {
                        mpFD.append(image, withName: "image", fileName: "chattImage", mimeType: "image/jpeg")
                    }
                }, to: apiUrl, method: .post).response { response in
                    switch (response.result) {
                    case .success:
                        print("createUser: new chat created!")
                    case .failure:
                        print("createUser: new chat failed")
                    }
                }
    }
    
    
}

