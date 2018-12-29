//
//  ViewController.swift
//  SwiftyCoreDataExample
//
//  Created by Michał Wójtowicz on 20/12/2018.
//  Copyright © 2018 Michał Wójtowicz. All rights reserved.
//

import UIKit
import SwiftyCoreData

class CatsViewController: UIViewController {

    let viewModel = CatsViewModel()
    
    lazy var viewBuilder = CatsViewBuilder(with: self.view)
    
    lazy var tableController = CatsTableViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        viewBuilder.build()
        viewModel.loadCats()
        bindUI()
        bindViewModel()
    }
    
    private func bindUI() {
        viewBuilder.tableView.delegate = tableController
        viewBuilder.tableView.dataSource = tableController
        viewBuilder.addButton.addTarget(self, action: #selector(addButtonTapped(_:)), for: .touchUpInside)
        viewBuilder.clearButton.addTarget(self, action: #selector(clearButtonTapped(_:)), for: .touchUpInside)
        viewBuilder.reloadButton.addTarget(self, action: #selector(reloadButtonTapped(_:)), for: .touchUpInside)
    }
    
    private func bindViewModel() {
        viewModel.catsChanged = { [weak self] cats in
            self?.tableController.cats = cats
            self?.viewBuilder.tableView.reloadData()
        }
    }
    
    @objc func addButtonTapped(_ sender: UIButton) {
        
    }
    
    @objc func clearButtonTapped(_ sender: UIButton) {
        viewModel.deleteCats()
        viewModel.loadCats()
    }
    
    @objc func reloadButtonTapped(_ sender: UIButton) {
        viewModel.restoreCats()
        viewModel.loadCats()
    }
   
}

