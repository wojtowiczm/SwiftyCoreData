//
//  CatsTableViewController.swift
//  SwiftyCoreDataExample
//
//  Created by Michał Wójtowicz on 29/12/2018.
//  For license see LICENSE.txt
//

import UIKit

class CatsTableViewController: NSObject {
    
    var cats: [Cat] = []
}

extension CatsTableViewController: UITableViewDelegate {
    
}

extension CatsTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: CatTableViewCell.id, for: indexPath) as? CatTableViewCell {
            cell.configure(with: cats[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
    
    
}
