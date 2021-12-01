//
//  TableView-Ext.swift
//  swiftChatter
//
//  Created by Griffin Kaufman on 12/1/21.
//  Copyright © 2021 The Regents of the University of Michigan. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {
    
    static func emptyCell() -> UITableViewCell {
        let cell = UITableViewCell()
        cell.selectionStyle = .none
        return cell
    }
    
    func scrollToBottom(animated: Bool = true) {
        
        DispatchQueue.main.async {
            
            var yOffset: CGFloat = 0.0;

            if (self.contentSize.height > self.bounds.size.height) {
                yOffset = self.contentSize.height - self.bounds.size.height;
            }
            
            self.setContentOffset(CGPoint(x: 0, y: yOffset), animated: animated)
        }
    }
}
