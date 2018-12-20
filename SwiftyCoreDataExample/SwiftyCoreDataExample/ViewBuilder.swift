//
//  ViewBuilder.swift
//  SwiftyCoreDataExample
//
//  Created by Michał Wójtowicz on 20/12/2018.
//  Copyright © 2018 Michał Wójtowicz. All rights reserved.
//

import UIKit

class ViewBuilder {
    
    let parentView: UIView
    
    lazy var buttonsStackView: UIStackView = {
        return UIStackView().layoutable()
    }()
    
    init(with parentView: UIView) {
        self.parentView = parentView
    }
    
    lazy var tableView: UITableView = {
        return UITableView().layoutable()
    }()
    
    func build() {
        
    }
    
    private func setupConstraints() {
        buttonsStackView.topAnchor.constraint(equalTo: parentView.topAnchor)
        buttonsStackView.leadingAnchor.constraint(equalTo: parentView.leadingAnchor)
        buttonsStackView.trailingAnchor.constraint(equalTo: parentView.trailingAnchor)
        buttonsStackView.activateConstraints()
        
        tableView.topAnchor.constraint(equalTo: buttonsStackView.bottomAnchor)
        tableView.leadingAnchor.constraint(equalTo: parentView.leadingAnchor)
        tableView.trailingAnchor.constraint(equalTo: parentView.trailingAnchor)
        tableView.bottomAnchor.constraint(equalTo: parentView.bottomAnchor)
        tableView.activateConstraints()
    }
}

extension UIView {
    
    func activateConstraints() {
        constraints.forEach { $0.isActive = true }
    }
    
    func layoutable() -> Self {
        translatesAutoresizingMaskIntoConstraints = false
        return self
    }
    
    
}
