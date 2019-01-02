//
//  NSLayoutAnchor.swift
//  SwiftyCoreDataExample
//
//  Created by Michał Wójtowicz on 29/12/2018.
//  Copyright © 2018 Michał Wójtowicz. All rights reserved.
//

import UIKit

extension NSLayoutAnchor {
    
    @discardableResult
    @objc func equalTo(_ anchor: NSLayoutAnchor<AnchorType>, constant c: CGFloat = 0.0) -> NSLayoutConstraint {
        let c = constraint(equalTo: anchor, constant: c)
        c.isActive = true
        return c
    }
}
