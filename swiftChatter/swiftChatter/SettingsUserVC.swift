//
//  SettingsUserVC.swift
//  swiftChatter
//
//  Created by Robert Manning on 12/8/21.
//  Copyright © 2021 The Regents of the University of Michigan. All rights reserved.
//

import Foundation
import UIKit

final class SettingsUserVC: UIViewController{
    
    @IBOutlet weak var first_name_label: UILabel!
    @IBOutlet weak var username_label: UILabel!
    @IBOutlet weak var last_name_label: UILabel!
    @IBOutlet weak var email_label: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        SettingsUser.shared.get_user_info { success in
            DispatchQueue.main.async {
                if success {
                    self.first_name_label.text = SettingsUser.shared.settings.firstnameU
                    self.last_name_label.text = SettingsUser.shared.settings.lastnameU
                    self.username_label.text = SettingsUser.shared.settings.usernameU
                    self.email_label.text = SettingsUser.shared.settings.emailU
                }
            }
        }
//        first_name_label.text = SettingsUser.shared.settings.firstnameU
//        last_name_label.text = SettingsUser.shared.settings.lastnameU
//        username_label.text = SettingsUser.shared.settings.usernameU
//        email_label.text = SettingsUser.shared.settings.emailU
    }
}
