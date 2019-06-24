//
//  ViewController.swift
//  SwiftyCoreDataExample
//
//  Created by Michał Wójtowicz on 20/12/2018.
//  For license see LICENSE.txt
//

import UIKit
import SwiftyCoreData

class CatsViewController: UIViewController {

    let viewModel = CatsViewModel()
    
    lazy var viewBuilder = CatsViewBuilder(with: self.view)
    
    lazy var tableController = CatsTableViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        bindUI()
        view.backgroundColor = .red
        viewBuilder.build()
    }
    
    private func bindUI() {
        viewBuilder.tableView.delegate = tableController
        viewBuilder.tableView.dataSource = tableController
        viewBuilder.loadButton.addTarget(self, action: #selector(loadButtonTapped(_:)), for: .touchUpInside)
        viewBuilder.saveButton.addTarget(self, action: #selector(saveButtonTapped(_:)), for: .touchUpInside)
        viewBuilder.deleteButton.addTarget(self, action: #selector(deleteButtonTapped(_:)), for: .touchUpInside)
    }
    
    private func bindViewModel() {
        viewModel.catsUpdated = { [weak self] cats in
            self?.tableController.cats = cats
            self?.viewBuilder.tableView.reloadData()
        }
        
        viewModel.benchmarkTimeUpdated = { [weak self] time, operation in
            self?.viewBuilder.benchmarkLabel.text = "Benchmark time: \(String(format: "%.3f", time * 1000))ms operation: \(operation.localizedName)"
        }
    }
    
    @objc func loadButtonTapped(_ sender: UIButton) {
        viewModel.loadCats()
    }
    
    @objc func saveButtonTapped(_ sender: UIButton) {
        viewModel.saveCats()
    }
    
    @objc func deleteButtonTapped(_ sender: UIButton) {
        viewModel.deleteCats(tableController.cats)
    }
   
}

