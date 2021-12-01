//
//  ChattTableCell.swift
//  swiftChatter
//
//  Created by sugih on 7/24/20.
//  Copyright © 2020 The Regents of the University of Michigan. All rights reserved.
//
import UIKit

final class ChattTableCell: UITableViewCell {
    
    @IBOutlet weak var groupChatName: UILabel!
    @IBOutlet weak var latestMessage: UILabel!
    @IBOutlet weak var timeStamp: UILabel!
}
