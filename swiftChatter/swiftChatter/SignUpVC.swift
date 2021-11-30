//
//  File.swift
//  swiftChatter
//
//  Created by Chase Cohn on 11/30/21.
//  Copyright © 2021 The Regents of the University of Michigan. All rights reserved.
//

import Foundation
import UIKit

class SignUpVC: UIViewController{
    
    
    @IBOutlet weak var Email: UITextField!
   
    @IBOutlet weak var LastName: UITextField!
    @IBOutlet weak var FirstName: UITextField!

    @IBOutlet weak var Username: UITextField!
    
    @IBOutlet weak var Password: UITextField!
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    @IBOutlet weak var InvalidEmail: UILabel!
    @IBAction func Submit(_ sender: Any) {
        print("hello")
        let userName: String = Username.text!
        let pass: String = Password.text!
        let email: String = Email.text!
        let firstName: String = FirstName.text!
        let lastName: String = LastName.text!
        let profilPic: String = "image.img"
        print(userName)
        print(pass)
        print(email)
        print(firstName)
        print(lastName)
        print(profilPic)
        let validEmail = isValidEmail(email)
        print(validEmail)
        if validEmail {
          self.performSegue(withIdentifier: "ID2", sender: self)
        }
        else {
            InvalidEmail.text = "Invalid Email"
        }

        let postUrl = URL(string: "urlString")
        var postRequest = URLRequest(url: postUrl!)
        postRequest.httpMethod = "POST"
        let params: [String: Any] = [
            "username" : userName,
            "password" : pass,
            "first_name" : firstName,
            "last_name" : lastName,
            "email" : email,
            "profile_pic" : profilPic,
        ]
//        postRequest.httpBody = params
        
    }
    
    
//
//    @IBOutlet weak var Submitt: UIButton!
//    @IBAction func Submit(_ sender: Any) {
//        print("hello")
//        let userName: String = Username.text!
//        let pass: String = Password.text!
//        print(userName)
//        print(pass)
//        TestLabel.text = "\(userName)"
//
//            }
//}

}

