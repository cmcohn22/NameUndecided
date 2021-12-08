//
//  ChattTableCell.swift
//  swiftChatter
//
//  Created by sugih on 7/24/20.
//  Copyright © 2020 The Regents of the University of Michigan. All rights reserved.
//
import UIKit


final class ChattTableCell: UITableViewCell {
    
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var groupchatnameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var imageLabel: UIImageView!
    var chatID: String!
    //@IBOutlet weak var chatIDLabel: UILabel?
//    @IBAction func actionSegue(_ sender: UIAction){
//        perfo
//    }
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
//        if(segue.identifier == "SpecificChatSegue"){
//
//        }
//        if let secondVC = segue.destination as? MessageVC
//        {
//        secondVC.chat_id = imageView.image
//        secondVC.image_name = txtEnterText.text
//        }
//    }
}
