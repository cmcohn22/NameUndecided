//
//  LogInVC.swift
//  swiftChatter
//
//  Created by Mac Pro PD on 12/1/21.
//  Copyright © 2021 The Regents of the University of Michigan. All rights reserved.
//

import UIKit


final class LoginInVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate{

    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var passWord: UITextField!
    @available(iOS 15.0.0, *)
    @IBAction func login(_ sender: Any) async {
        let user = User(username: self.userName.text,
                        password: self.passWord.text)
        await UserStore.shared.login(user)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        userName.delegate = self
        passWord.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        userName.resignFirstResponder()
        passWord.resignFirstResponder()
        return true
    }

}
