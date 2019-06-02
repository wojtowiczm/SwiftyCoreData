//
//  NSLayoutAnchor.swift
//  SwiftyCoreDataExample
//
//  Created by Michał Wójtowicz on 29/12/2018.
//  For license see LICENSE.txt
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
