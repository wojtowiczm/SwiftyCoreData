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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewBuilder.build()
        viewModel.loadCats()
    }
    
    private func bindViewModel() {
        viewModel.catsChanged = { [weak self] cats in
            self?.viewBuilder.tableView.reloadData()
        }
    }
}

