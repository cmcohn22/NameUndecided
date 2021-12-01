//
//  MessageSendTableViewCell.swift
//  swiftChatter
//
//  Created by Griffin Kaufman on 12/1/21.
//  Copyright © 2021 The Regents of the University of Michigan. All rights reserved.
//

import UIKit

class MessageSendTableViewCell: UITableViewCell {

    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    
    @IBOutlet weak var viewContainer: UIView!{
        didSet {
            viewContainer.layer.cornerRadius = 8.0
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureCell(_ message: Message) {
        
        self.lblMessage.text = message.message ?? ""
        self.lblDate.text = message.date ?? ""
    }
}
