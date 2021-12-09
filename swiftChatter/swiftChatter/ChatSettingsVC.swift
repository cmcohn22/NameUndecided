//
//  ChatSettingsVC.swift
//  swiftChatter
//
//  Created by Griffin Kaufman on 12/8/21.
//  Copyright © 2021 The Regents of the University of Michigan. All rights reserved.
//

import UIKit

final class ChatUsersTableCell: UITableViewCell {
    
    @IBOutlet weak var fullnameLabel: UILabel!
    @IBOutlet weak var adminLabel: UILabel!
    
}

//, UITableViewDelegate, UITableViewDataSource
final class ChatSettingsVC: UIViewController {
    
    var chat_id : String?
    var chat_name : String?
    var chat_description : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        ChatSettings.shared.get_chat_info(chat_id: chat_id!, chatName: chat_name!, chatDesc: chat_description!) { success in
            DispatchQueue.main.async {
                if success {
                    self.MnkyChatName.text = self.chat_name
                    self.MnkyChatDescription.text = self.chat_description
                }
            }
        }
    }
    
    
    @IBOutlet weak var MnkyChatName: UILabel!
    @IBOutlet weak var MnkyChatDescription: UILabel!
    @IBOutlet weak var ChatUsersTableView: UITableView!
}
