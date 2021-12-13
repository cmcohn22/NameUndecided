//
//  Extensions.swift
//  swiftChatter
//
//  Created by Mac Pro PD on 11/30/21.
//  Copyright © 2021 The Regents of the University of Michigan. All rights reserved.
//
import UIKit

extension UIImage {
    func resizeImage(targetSize: CGSize) -> UIImage? {
        // Figure out orientation, and use it to form the rectangle
        let ratio = (targetSize.width > targetSize.height) ?
            targetSize.height / size.height :
            targetSize.width / size.width
        
        let newSize = CGSize(width: size.width * ratio, height: size.height * ratio)
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the calculated rectangle
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}

extension UIScrollView {

    func scrollToTop(animated: Bool) {
        let topOffset = CGPoint(x: 0, y: -contentInset.top)
        setContentOffset(topOffset, animated: animated)
    }

}

extension UIViewController {
    func add(_ child: UIViewController) {
        addChild(child)
        view.addSubview(child.view)
        child.didMove(toParent: self)
    }

    func remove() {
        // Just to be safe, we check that this view controller
        // is actually added to a parent before removing it.
        guard parent != nil else {
            return
        }

        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
}
