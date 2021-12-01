////
////  PostVC.swift
////  swiftChatter
////
////  Created by sugih on 7/24/20.
////  Copyright © 2020 The Regents of the University of Michigan. All rights reserved.
////
//import UIKit
//
//final class PostVC: UIViewController {
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Do any additional setup after loading the view.
//    }
//
//    @IBOutlet weak var usernameLabel: UILabel!
//    @IBOutlet weak var messageTextView: UITextView!
//
//    @IBAction func submitChatt(_ sender: Any) {
//        ChattStore.shared.postChatt(Chatt(username: usernameLabel.text,
//                                          message: messageTextView.text))
//
//        dismiss(animated: true, completion: nil)
//    }
//}
