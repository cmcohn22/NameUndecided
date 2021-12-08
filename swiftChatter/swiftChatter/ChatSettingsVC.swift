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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        ChatSettings.shared.get_chat_info { success in
            DispatchQueue.main.async {
                if success {
                    self.MnkyChatName.text = ChatSettings.shared.chat_name
                    self.MnkyChatDescription.text = ChatSettings.shared.chat_description
                }
            }
        }
    }
    
    
    @IBOutlet weak var MnkyChatName: UILabel!
    @IBOutlet weak var MnkyChatDescription: UILabel!
    @IBOutlet weak var ChatUsersTableView: UITableView!
}
