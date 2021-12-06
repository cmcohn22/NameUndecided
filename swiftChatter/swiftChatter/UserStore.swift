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

    private let serverUrl = "https://mnky-chat.com/api/"
    
    func createUser(_ user: User, profile_pic: UIImage?)  {
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
                    if let profile_pic = profile_pic?.jpegData(compressionQuality: 1.0) {
                        mpFD.append(profile_pic, withName: "profile_pic", fileName: "profile_pic", mimeType: "image/jpeg")
                    }
                }, to: apiUrl, method: .post).response { response in
                    switch (response.result) {
                    case .success:
                        print("createUser: new user created!")
                    case .failure:
                        print("createUser: new user failed")
                    }
                }
    }
    @available(iOS 15.0.0, *)
    func login(_ user: User) async {
        guard let apiUrl = URL(string: serverUrl+"login/") else {
            print("createUser: Bad URL")
            return
        }
        let jsonObj = ["username": user.username,
                       "password": user.password]
        guard let jsonData = try? JSONSerialization.data(withJSONObject: jsonObj) else {
            print("postChatt: jsonData serialization error")
            return
        }
        
        var request = URLRequest(url: apiUrl)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        do {
            let (_, response) = try await URLSession.shared.data(for: request)

            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("postChatt: HTTP STATUS: \(httpStatus.statusCode)")
                return
            }
        } catch {
            print("postChatt: NETWORKING ERROR")
        }
    }
    
}

