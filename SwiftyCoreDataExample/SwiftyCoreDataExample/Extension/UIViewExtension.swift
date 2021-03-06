//
//  UIViewExtension.swift
//  SwiftyCoreDataExample
//
//  Created by Michał Wójtowicz on 21/12/2018.
//  For license see LICENSE.txt
//

import UIKit

extension UIView {
    
    func activateConstraints() {
        constraints.forEach { $0.isActive = true }
    }
    
    func layoutable() -> Self {
        translatesAutoresizingMaskIntoConstraints = false
        return self
    }
    
    func edges(equalTo other: UIView) {
        topAnchor.equalTo(other.topAnchor)
        leadingAnchor.equalTo(other.leadingAnchor)
        trailingAnchor.equalTo(other.trailingAnchor)
        bottomAnchor.equalTo(other.bottomAnchor)
    }
}
