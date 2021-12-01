//
//  SignUpVC.swift
//  swiftChatter
//
//  Created by Mac Pro PD on 11/30/21.
//  Copyright © 2021 The Regents of the University of Michigan. All rights reserved.
//

import UIKit

final class SignUpVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate{

    
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var passWord: UITextField!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var email: UITextField!
    @IBAction func pickMedia(_ sender: Any) {
        presentPicker(.photoLibrary)
    }
    
    @IBAction func accessCamera(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            presentPicker(.camera)
        } else {
            print("Camera not available. iPhone simulators don't simulate the camera.")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        userName.delegate = self
        passWord.delegate = self
        firstName.delegate = self
        lastName.delegate = self
        email.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        userName.resignFirstResponder()
        passWord.resignFirstResponder()
        firstName.resignFirstResponder()
        lastName.resignFirstResponder()
        email.resignFirstResponder()
        return true
    }
    
    private func presentPicker(_ sourceType: UIImagePickerController.SourceType) {
            let imagePickerController = UIImagePickerController()
            imagePickerController.sourceType = sourceType
            imagePickerController.delegate = self
            imagePickerController.allowsEditing = true
            imagePickerController.mediaTypes = ["public.image"]
            present(imagePickerController, animated: true, completion: nil)
        }
    
    @IBAction func creatAccount(_ sender: Any) {
        if isUserInformationValid() == false {
            print("Please fill out all the required information")
        }
        let user = User(username: self.userName.text,
                        password: self.passWord.text,
                        first_name: self.firstName.text,
                        last_name: self.lastName.text,
                        email: self.email.text)
        UserStore.shared.createUser(user, image: profilePic.image)
        dismiss(animated: true, completion: nil)
        
    }
    
    private func isUserInformationValid() -> Bool {
        if userName.state.isEmpty {
                return false
        }
            
        if firstName.state.isEmpty {
                return false
        }
            
        if lastName.state.isEmpty {
                return false
        }
            
        if email.state.isEmpty {
                return false
        }
        
        if passWord.state.isEmpty {
            return false
        }
            
            return true
        }
}

