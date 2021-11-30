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
    
    @IBOutlet weak var TestLabel: UILabel!

    @IBOutlet weak var Username: UITextField!
    
    @IBOutlet weak var Password: UITextField!
    
    @IBAction func Submit(_ sender: Any) {
        print("hello")
        let userName: String = Username.text!
        let pass: String = Password.text!
        print(userName)
        print(pass)
        TestLabel.text = "\(userName)"
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

