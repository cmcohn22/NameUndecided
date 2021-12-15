//
//  MessageTableCellPicture.swift
//  swiftChatter
//
//  Created by Mac Pro PD on 12/12/21.
//  Copyright © 2021 The Regents of the University of Michigan. All rights reserved.
//

import UIKit

final class MessageTableCellPicture: UITableViewCell, UITextViewDelegate {
  
    @IBOutlet weak var first_name: UILabel!
    
    @IBOutlet weak var pdfFile: UITextView!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var content: UIImageView!
    @IBOutlet weak var last_name: UILabel!
    
    func textView(_ pdfFile: UITextView, shouldInteractWith URL: URL, in
                 characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        UIApplication.shared.open(URL)
        return false
    }
}
