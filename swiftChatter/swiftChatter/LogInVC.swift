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
                        if(response.response?.statusCode == 200){
                            let jsondic = json as! NSDictionary
                            //let responseString = String(data: json, encoding: .utf8)
                            self.InvalidLogIn.text = ""
                            let tken = jsondic["token"] as! String
                            UserStore.shared.setToken(token: tken)
                            StartUpVC.shared.makeConnect()
                            self.performSegue(withIdentifier: "ID1", sender: self)
                        }
                        else{
                            self.InvalidLogIn.text = "Invalid Login"
                        }

                    }
                    break
                case .failure(let error):
                    self.InvalidLogIn.text = "Invalid Login"
                    break
                }
            }
    }
    }
