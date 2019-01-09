//
//  DataSet.swift
//  SwiftyCoreDataExample
//
//  Created by Michał Wójtowicz on 08/01/2019.
//  Copyright © 2019 Michał Wójtowicz. All rights reserved.
//

import Foundation

class DataSet {
    static let base: [Cat] = [
        Cat(name: "Figaro", weight: 3.1, age: 2, managedObjectID: nil),
        Cat(name: "Wilfredo", weight: 3212.4, age: 3123, managedObjectID: nil),
        Cat(name: "Brun2klJFDIDSo", weight: 1.2, age: 1, managedObjectID: nil),
        Cat(name: "FigarSDCSSCo", weight: 3.1, age: 2, managedObjectID: nil),
        Cat(name: "WilfAredo", weight: 2.3231321312, age: 31231231, managedObjectID: nil),
        Cat(name: "Bruno", weight: 112312321321.22, age: 1, managedObjectID: nil),
        Cat(name: "Figaro", weight: 31123.11, age: 3212, managedObjectID: nil),
        Cat(name: "Wilfredo", weight: 1.4, age: 3, managedObjectID: nil),
        Cat(name: "Bruno", weight: 1.2, age: 1, managedObjectID: nil),
        Cat(name: "Figaro", weight: 3.1, age: 2, managedObjectID: nil),
  
    ]
    
    static let oneHoundredThousandCats: [Cat] = {
        var toReturn: [[Cat]] = []
        for i in 0..<1000 {
            toReturn.append(DataSet.base)
        }
        return toReturn.flatMap { $0 }
    }()
}
