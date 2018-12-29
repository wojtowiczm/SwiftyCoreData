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
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView().layoutable()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(CatTableViewCell.self, forCellReuseIdentifier: CatTableViewCell.id)
        return tableView
    }()
    
    init(with parentView: UIView) {
        self.parentView = parentView
    }
    
    func build() {
        setupProperties()
        setupHierarchy()
        setupConstraints()
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
        buttonsStackView.topAnchor.equalTo(parentView.safeAreaLayoutGuide.topAnchor)
        buttonsStackView.leadingAnchor.equalTo(parentView.leadingAnchor)
        buttonsStackView.trailingAnchor.equalTo(parentView.trailingAnchor)

        tableView.topAnchor.equalTo(buttonsStackView.bottomAnchor)
        tableView.leadingAnchor.equalTo(parentView.leadingAnchor)
        tableView.trailingAnchor.equalTo(parentView.trailingAnchor)
        tableView.bottomAnchor.equalTo(parentView.bottomAnchor)
    }
}
