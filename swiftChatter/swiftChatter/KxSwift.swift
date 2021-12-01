//
//  KxSwift.swift
//  swiftChatter
//
//  Created by Griffin Kaufman on 12/1/21.
//  Copyright © 2021 The Regents of the University of Michigan. All rights reserved.
//

import Foundation

class KxSwift<T> {
    
    typealias Observer = (T) -> ()
    var observer: Observer?
    
    var value: T {
        didSet {
            observer?(value)
        }
    }
    
    init(_ v: T) {
        value = v
    }
    
    func bind(_ listner: Observer?) {
        self.observer = listner
    }
    
    func subscribe(_ observer: Observer?) {
        self.observer = observer
        observer?(value)
    }
    
}
