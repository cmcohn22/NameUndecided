//
//  SettingsUserVC.swift
//  swiftChatter
//
//  Created by Griffin Kaufman on 12/11/21.
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
        self.first_name_label.text = UserStore.shared.activeUser.first_name
        self.last_name_label.text = UserStore.shared.activeUser.last_name
        self.username_label.text = UserStore.shared.activeUser.username
        self.email_label.text = UserStore.shared.activeUser.email
    }
//        first_name_label.text = SettingsUser.shared.settings.firstnameU
//        last_name_label.text = SettingsUser.shared.settings.lastnameU
//        username_label.text = SettingsUser.shared.settings.usernameU
//        email_label.text = SettingsUser.shared.settings.emailU
}
