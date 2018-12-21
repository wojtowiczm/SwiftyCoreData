//
//  ViewBuilder.swift
//  SwiftyCoreDataExample
//
//  Created by Michał Wójtowicz on 20/12/2018.
//  Copyright © 2018 Michał Wójtowicz. All rights reserved.
//

import UIKit

class CatsViewBuilder {
    
    let parentView: UIView
    
    lazy var reloadButton: UIButton = {
        let button = UIButton().layoutable()
        return button
    }()
    
    lazy var clearButton: UIButton = {
        let button = UIButton().layoutable()
        return button
    }()
    
    lazy var addButton: UIButton = {
        let button = UIButton().layoutable()
        return button
    }()
    
    lazy var buttonsStackView: UIStackView = {
        let stackView = UIStackView().layoutable()
        stackView.axis = .horizontal
        return stackView
    }()
    
    init(with parentView: UIView) {
        self.parentView = parentView
    }
    
    lazy var tableView: UITableView = {
        let tableView = UITableView().layoutable()
        tableView.rowHeight = UITableView.automaticDimension
        return tableView
    }()
    
    func build() {
        setupProperties()
        setupHierarchy()
        setupConstraints()
        activateConstraints()
    }
    
    private func setupProperties() {
        clearButton.setTitle("CLEAR", for: .normal)
        reloadButton.setTitle("RELOAD", for: .normal)
        addButton.setTitle("ADD", for: .normal)
    }
    
    private func setupHierarchy() {
        [clearButton, reloadButton, addButton].forEach { buttonsStackView.addArrangedSubview($0) }
        [buttonsStackView, tableView].forEach { parentView.addSubview($0) }
    }
    
    private func setupConstraints() {
        buttonsStackView.topAnchor.constraint(equalTo: parentView.topAnchor)
        buttonsStackView.leadingAnchor.constraint(equalTo: parentView.leadingAnchor)
        buttonsStackView.trailingAnchor.constraint(equalTo: parentView.trailingAnchor)
        
        tableView.topAnchor.constraint(equalTo: buttonsStackView.bottomAnchor)
        tableView.leadingAnchor.constraint(equalTo: parentView.leadingAnchor)
        tableView.trailingAnchor.constraint(equalTo: parentView.trailingAnchor)
        tableView.bottomAnchor.constraint(equalTo: parentView.bottomAnchor)
    }
    
    private func activateConstraints() {
        buttonsStackView.activateConstraints()
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
