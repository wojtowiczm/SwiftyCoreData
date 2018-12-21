//
//  UIViewExtension.swift
//  SwiftyCoreDataExample
//
//  Created by Michał Wójtowicz on 21/12/2018.
//  Copyright © 2018 Michał Wójtowicz. All rights reserved.
//

import UIView

extension UIView {
    
    func activateConstraints() {
        constraints.forEach { $0.isActive = true }
    }
    
    func layoutable() -> Self {
        translatesAutoresizingMaskIntoConstraints = false
        return self
    }
}