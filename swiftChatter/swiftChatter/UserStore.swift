//
//  UserStore.swift
//  swiftChatter
//
//  Created by Mac Pro PD on 12/6/21.
//  Copyright © 2021 The Regents of the University of Michigan. All rights reserved.
//
import Foundation
import UIKit
import Alamofire
import CoreLocation


final class UserStore: ObservableObject {
    static let shared = UserStore() // create one instance of the class to be shared
    private init() {}                // and make the constructor private so no other
                                     // instances can be created
    @Published private(set) var activeUser: User = User()


    private let serverUrl = "https://mnky-chat.com/api/"
    func setToken(token: String){
        self.activeUser.tokenId = token
        
    }
    func getUserInfo()  {
        guard let apiUrl = URL(string: serverUrl+"user-info/") else {
            print("getUserInfo: Bad URL")
            return
        }
        print("Token \(UserStore.shared.activeUser.tokenId!)")
        
         let tokenHeaders: HTTPHeaders = [
            "Authorization": "Token \(UserStore.shared.activeUser.tokenId!)"
        ]
        
        AF.request(apiUrl, method: .get, headers: tokenHeaders).responseJSON{
            (response) in
            print(response)
            
            if let result = response.value{
                let JSON = result as! NSDictionary
                print(JSON)
                let usernme = (JSON.object(forKey: "username") as! String)
                let emal = (JSON.object(forKey: "email") as! String)
                let firstName = (JSON.object(forKey: "first_name") as! String)
                let lastName = (JSON.object(forKey: "last_name") as! String)
                let tempUser = User(username: usernme, first_name: firstName, last_name: lastName, email: emal, tokenId: self.activeUser.tokenId)
                self.activeUser = tempUser
            }
        }
        
        
    }
    func changeProImg(imageIn: UIImage?){
        let tokenHeaders: HTTPHeaders = [
            "Authorization": "Token \(UserStore.shared.activeUser.tokenId!)"
        ]
        guard let apiUrl = URL(string: "https://mnky-chat.com/api/profile-pic/") else {
            print("signup: Bad URL")
            return
        }
        AF.upload(multipartFormData: { mpFD in
            if let image = imageIn?.jpegData(compressionQuality: 1.0) {
                        mpFD.append(image, withName: "profile_pic", fileName: "proPic", mimeType: "image/jpeg")
                    }
        }, to: apiUrl, method: .post, headers: tokenHeaders).responseJSON{ (response) in
            print(response.result)
            switch response.result {

            case .success(_):
                if let json = response.value
                {
                    if(response.response?.statusCode == 200){
                        print("successfully changed picture")
                    }

                }
                break
            case .failure(let error):
                break
            }
            
        }
    }
}
