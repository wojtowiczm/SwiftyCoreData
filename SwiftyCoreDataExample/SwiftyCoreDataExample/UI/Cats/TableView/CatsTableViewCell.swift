//
//  CatsTableViewCell.swift
//  SwiftyCoreDataExample
//
//  Created by Michał Wójtowicz on 29/12/2018.
//  For license see LICENSE.txt
//

import UIKit

class CatTableViewCell: UITableViewCell {
    
    static let id: String = "CatCell"
    
    lazy var catNameLabel: UILabel = {
        return UILabel().layoutable()
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        contentView.addSubview(catNameLabel)
        catNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor)
        catNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
        catNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        catNameLabel.activateConstraints()
    }
    
    func configure(with cat: Cat) {
        catNameLabel.text = cat.name
    }
}
