//
//  File.swift
//  swiftChatter
//
//  Created by Chase Cohn on 11/30/21.
//  Copyright © 2021 The Regents of the University of Michigan. All rights reserved.
//

import Foundation
import UIKit

class SignUpVC: UIViewController, UITextFieldDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        Email.delegate = self
        FirstName.delegate = self
        LastName.delegate = self
        Username.delegate = self
        Password.delegate = self
    }
        
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        Email.resignFirstResponder()
        FirstName.resignFirstResponder()
        LastName.resignFirstResponder()
        Username.resignFirstResponder()
        Password.resignFirstResponder()
        return true
    }
    
    
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

    @IBOutlet weak var EmptyFirstName: UILabel!
    
    @IBOutlet weak var EmptyLastName: UILabel!
    @IBOutlet weak var EmptyUserName: UILabel!
    
    @IBOutlet weak var EmptyPassword: UILabel!
    @IBAction func Submit(_ sender: Any) {
        print("hello")
        let userName: String = Username.text!
        let pass: String = Password.text!
        let email: String = Email.text!
        let firstName: String = FirstName.text!
        let lastName: String = LastName.text!
        let profilePic: String = "image.img"
        print(userName)
        print(pass)
        print(email)
        print(firstName)
        print(lastName)
        print(profilePic)
        let validEmail = isValidEmail(email)
        print(validEmail)
        if !validEmail{
            InvalidEmail.text = "Invalid Email"
        }
        else {
            InvalidEmail.text = ""
        }
        if firstName == "" || firstName.count > 18{
            EmptyFirstName.text = "Invalid First Name"
        }
        else {
            EmptyFirstName.text = ""
        }
        if lastName == "" || lastName.count > 18{
            EmptyLastName.text = "Invalid Last Name"
        }
        else {
            EmptyLastName.text = ""
        }
        if userName == "" || userName.count > 18{
            EmptyUserName.text = "Invalid Username"
        }
        else {
            EmptyUserName.text = ""
        }
        if pass == "" || pass.count > 18{
            EmptyPassword.text = "Invalid Password"
        }
        else {
            EmptyPassword.text = ""
        }
        if validEmail && userName != "" && pass != "" && firstName != "" && lastName != "" && profilePic != ""{
          self.performSegue(withIdentifier: "ID2", sender: self)
        }
        
        let url = URL(string: "https://mnky-chat.com/api/signup/")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let parameters: [String: Any] = [
            "username": userName,
            "password": pass,
            "first_name": firstName,
            "last_name": lastName,
            "email": email,
        ]
        do {
               request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
           } catch let error {
               print(error.localizedDescription)
           }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data,
                let response = response as? HTTPURLResponse,
                error == nil else {                                              // check for fundamental networking error
                print("error", error ?? "Unknown error")
                return
            }

            guard (200 ... 299) ~= response.statusCode else {                    // check for http errors
                print("statusCode should be 2xx, but is \(response.statusCode)")
                print("response = \(response)")
                return
            }

            let responseString = String(data: data, encoding: .utf8)
            print("Segueing")
            do{
                let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
                let tken = json!["token"] as! String ?? "failtonke"
                print("responseString = \(responseString)")
               print("responseString = \(tken)")
                UserStore.shared.setToken(token: tken)
                StartUpVC.shared.makeConnect()
            }catch{ print("erroMsg") }
            print("responseString = \(responseString)")
        }

        task.resume()

        let postUrl = URL(string: "urlString")
        var postRequest = URLRequest(url: postUrl!)
        postRequest.httpMethod = "POST"
        let params: [String: Any] = [
            "username" : userName,
            "password" : pass,
            "first_name" : firstName,
            "last_name" : lastName,
            "email" : email,
            "profile_pic" : profilePic,
        ]
        }
}
