//
//  LogInVC.swift
//  swiftChatter
//
//  Created by Chase Cohn on 11/30/21.
//  Copyright © 2021 The Regents of the University of Michigan. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class LogInVC: UIViewController, UITextFieldDelegate{
    
    @IBOutlet weak var Username: UITextField!
    @IBOutlet weak var Password: UITextField!
    
    @IBOutlet weak var InvalidLogIn: UILabel!
    
    override func viewDidLoad() {
            super.viewDidLoad()
            
            Username.delegate = self
            Password.delegate = self
    }
        
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        Username.resignFirstResponder()
        Password.resignFirstResponder()
        return true
    }
       
    @IBAction func Submit(_ sender: Any) {
        InvalidLogIn.text = ""
        let userName: String = Username.text!
        let pass: String = Password.text!
        var checker: Bool = false
        
        let url = "https://mnky-chat.com/api/login/"
        let parameters: [String: Any] = [
            "username": userName,
            "password": pass,
        ]
        AF.request(URL.init(string: url)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
                print(response.result)

                switch response.result {

                case .success(_):
                    if let json = response.value
                    {
                        //print(json)
                        //print(response.response?.statusCode)
                        if(response.response?.statusCode == 200){
                            let jsondic = json as! NSDictionary
                            //let responseString = String(data: json, encoding: .utf8)
                            self.InvalidLogIn.text = ""
                           // print("Segueing")
                            let tken = jsondic["token"] as! String
                            //print("USERTOKEN SUCSIG")
                            //print(self.userToken)
                          //  print(tken)
                            UserStore.shared.setToken(token: tken)
                            StartUpVC.shared.makeConnect()
                            self.performSegue(withIdentifier: "ID1", sender: self)
                        }
                        else{
                            self.InvalidLogIn.text = "Invalid Login"
                        }
                        
//                        successHandler((json as! [String:AnyObject]))
                        

                    }
                    break
                case .failure(let error):
                    self.InvalidLogIn.text = "Invalid Login"
                    break
                }
            }
//        var request = URLRequest(url: url)
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.httpMethod = "POST"

//        do {
//               request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
//           } catch let error {
//               print(error.localizedDescription)
//           }
//
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//            guard let data = data,
//                let response = response as? HTTPURLResponse,
//                error == nil else {                                              // check for fundamental networking error
//                print("error", error ?? "Unknown error")
//                return
//            }
//            if(response.statusCode == 400){
//                print("uh oh")
//                checker = true
//                print(checker)
//
//            }
//            else{
//                DispatchQueue.main.async {
//                    self.InvalidLogIn.text = ""
//                    self.performSegue(withIdentifier: "ID1", sender: self)
//                }
//
//            }
//
//            guard (200 ... 299) ~= response.statusCode else {
//                // check for http errors
//
//                print("statusCode should be 2xx, but is \(response.statusCode)")
//                print("response = \(response)")
//                return
//            }
//
//            let responseString = String(data: data, encoding: .utf8)
//            print("responseString = \(String(describing: responseString))")
////            if (responseString?.contains("Incorrect")) {
////                DispatchQueue.main.async {
////                    print("incorrect - try again")
////
////                }
////            }
////            else {
////                DispatchQueue.main.async {
////                    print("correct good")
////                }
////            }
//        }
//
//        task.resume()
//
//        let postUrl = URL(string: "urlString")
//        var postRequest = URLRequest(url: postUrl!)
//        postRequest.httpMethod = "POST"
//        let params: [String: Any] = [
//            "username" : userName,
//            "password" : pass,
//        ]
//        InvalidLogIn.text = "hi"
        
//        print("---")
//        print(checker)
//        if(checker){
//            print("This is good")
////            DispatchQueue.main.async {
//                InvalidLogIn.text = "Invalid Credentials"
////            }
//        }
    }
    }
