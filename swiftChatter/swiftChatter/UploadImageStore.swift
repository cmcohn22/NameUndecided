//
//  UploadImageStore.swift
//  swiftChatter
//
//  Created by Mac Pro PD on 12/11/21.
//  Copyright © 2021 The Regents of the University of Michigan. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

final class UploadImageStore: ObservableObject {
    static let shared = UploadImageStore() // create one instance of the class to be shared
    private init() {}                // and make the constructor private so no other
                                     // instances can be created
    private let serverUrl = "https://mnky-chat.com/api/"
    
    private let tokenHeaders: HTTPHeaders = [
        "Authorization": "Token \(UserStore.shared.activeUser.tokenId!)"
    ]
    
    func uploadImage(image: UIImage?, _ chatId: String!, _ chatLat: Double!, _ chatLong: Double!)  {
        guard let apiUrl = URL(string: serverUrl+"upload-file/") else {
            print("createChatt: Bad URL")
            return
        }
        
        AF.upload(multipartFormData: { mpFD in
            if let lat = chatLat {
                mpFD.append("\(lat)".data(using: String.Encoding.utf8)!, withName: "lat")
                        print(lat)
                    }
            if let long = chatLong {
                mpFD.append("\(long)".data(using: String.Encoding.utf8)!, withName: "long")
                        print(long)
                    }
            if let chat_id = chatId{
                        mpFD.append(chat_id.data(using: .utf8)!, withName: "chat_id")
                            print(chat_id)
                    }
            if let image = image?.jpegData(compressionQuality: 1.0) {
                        mpFD.append(image, withName: "file", fileName: "messageImage", mimeType: "image/jpeg")
                    }
        }, to: apiUrl, method: .post, headers: tokenHeaders).responseJSON(completionHandler: { data in
                    print(data)
                    print("anticipated")
                })
    }
    
    func uploadDocument(pdfData: Data?, _ chatId: String!, _ chatLat: Double!, _ chatLong: Double!)  {
        guard let apiUrl = URL(string: serverUrl+"upload-file/") else {
            print("createChatt: Bad URL")
            return
        }
        
        AF.upload(multipartFormData: { mpFD in
            if let lat = chatLat {
                mpFD.append("\(lat)".data(using: String.Encoding.utf8)!, withName: "lat")
                        print(lat)
                    }
            if let long = chatLong {
                mpFD.append("\(long)".data(using: String.Encoding.utf8)!, withName: "long")
                        print(long)
                    }
            if let chat_id = chatId{
                        mpFD.append(chat_id.data(using: .utf8)!, withName: "chat_id")
                            print(chat_id)
                    }
            if let data = pdfData{
                mpFD.append(data as Data, withName: "file", fileName: "messagePDF", mimeType: "application/pdf")
                print(data[0])
            }
        }, to: apiUrl, method: .post, headers: tokenHeaders).responseJSON{ response in
            print(response)
            print("anticipated")
            }
    }
    
    
    
}
