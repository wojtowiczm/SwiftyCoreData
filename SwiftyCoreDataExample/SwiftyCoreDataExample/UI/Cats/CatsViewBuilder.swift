//
//  ViewBuilder.swift
//  SwiftyCoreDataExample
//
//  Created by Michał Wójtowicz on 20/12/2018.
//  For license see LICENSE.txt
//

import UIKit

class CatsViewBuilder {
    
    let parentView: UIView
    
    lazy var loadButton: UIButton = {
        let button = UIButton().layoutable()
        return button
    }()
    
    lazy var saveButton: UIButton = {
        let button = UIButton().layoutable()
        return button
    }()
    
    lazy var deleteButton: UIButton = {
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
    
    lazy var benchmarkLabel: UILabel = {
        let label = UILabel().layoutable()
        return label
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
        loadButton.setTitle("LOAD", for: .normal)
        saveButton.setTitle("SAVE", for: .normal)
        deleteButton.setTitle("DELETE", for: .normal)
    }
    
    private func setupHierarchy() {
        [loadButton, saveButton, deleteButton].forEach { buttonsStackView.addArrangedSubview($0) }
        [buttonsStackView, tableView, benchmarkLabel].forEach { parentView.addSubview($0) }
    }
    
    private func setupConstraints() {
        buttonsStackView.topAnchor.equalTo(parentView.safeAreaLayoutGuide.topAnchor)
        buttonsStackView.leadingAnchor.equalTo(parentView.leadingAnchor)
        buttonsStackView.trailingAnchor.equalTo(parentView.trailingAnchor)

        tableView.topAnchor.equalTo(buttonsStackView.bottomAnchor)
        tableView.leadingAnchor.equalTo(parentView.leadingAnchor)
        tableView.trailingAnchor.equalTo(parentView.trailingAnchor)
        tableView.bottomAnchor.equalTo(benchmarkLabel.topAnchor)
        
        benchmarkLabel.leadingAnchor.equalTo(parentView.leadingAnchor)
        benchmarkLabel.trailingAnchor.equalTo(parentView.trailingAnchor)
        benchmarkLabel.bottomAnchor.equalTo(parentView.bottomAnchor)
    }
}
