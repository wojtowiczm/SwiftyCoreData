//
//  ViewModel.swift
//  SwiftyCoreDataExample
//
//  Created by Michał Wójtowicz on 20/12/2018.
//  Copyright © 2018 Michał Wójtowicz. All rights reserved.
//

import CoreData
import SwiftyCoreData

enum BenchmarkOperationType {
    case load
    case delete
    case save
    
    var localizedName: String {
        switch self {
        case .load: return "Load"
        case .delete: return "Delete"
        case .save: return "Save"
        }
    }
}

class CatsViewModel {
    
    var catsUpdated: (([Cat]) -> Void)!
    
    var benchmarkTimeUpdated: ((Double, BenchmarkOperationType) -> Void)!
    
    private let dbController = SCDController<Cat, CatEntity>(with: PersistanceService.shared.persistanceContainer, operatingQueue: .main)
    
    func loadCats() {
        let startTime = CFAbsoluteTimeGetCurrent()
        dbController.fetchAll { [unowned self] in
            self.benchmarkTimeUpdated(CFAbsoluteTimeGetCurrent() - startTime, .load)
            self.catsUpdated($0)
        }
    }
    
    func deleteCats() {
        let startTime = CFAbsoluteTimeGetCurrent()
        dbController.batchDelete()
        benchmarkTimeUpdated(CFAbsoluteTimeGetCurrent() - startTime, .delete)
    }
    
    func saveCats() {
        let cats = [
            Cat(name: "Wilfredo", weight: 2.4, age: 3, managedObjectID: nil),
            Cat(name: "Bruno", weight: 1.2, age: 1, managedObjectID: nil),
            Cat(name: "Figaro", weight: 3.1, age: 2, managedObjectID: nil),
            Cat(name: "Wilfredo", weight: 2.4, age: 3, managedObjectID: nil),
            Cat(name: "Bruno", weight: 1.2, age: 1, managedObjectID: nil),
            Cat(name: "Figaro", weight: 3.1, age: 2, managedObjectID: nil),
            Cat(name: "Wilfredo", weight: 2.4, age: 3, managedObjectID: nil),
            Cat(name: "Bruno", weight: 1.2, age: 1, managedObjectID: nil),
            Cat(name: "Figaro", weight: 3.1, age: 2, managedObjectID: nil),
            Cat(name: "Wilfredo", weight: 2.4, age: 3, managedObjectID: nil),
            Cat(name: "Bruno", weight: 1.2, age: 1, managedObjectID: nil),
            Cat(name: "Figaro", weight: 3.1, age: 2, managedObjectID: nil),
            Cat(name: "Wilfredo", weight: 2.4, age: 3, managedObjectID: nil),
            Cat(name: "Bruno", weight: 1.2, age: 1, managedObjectID: nil),
            Cat(name: "Figaro", weight: 3.1, age: 2, managedObjectID: nil),
            Cat(name: "Wilfredo", weight: 2.4, age: 3, managedObjectID: nil),
            Cat(name: "Bruno", weight: 1.2, age: 1, managedObjectID: nil),
            Cat(name: "Figaro", weight: 3.1, age: 2, managedObjectID: nil),
            Cat(name: "Wilfredo", weight: 2.4, age: 3, managedObjectID: nil),
            Cat(name: "Bruno", weight: 1.2, age: 1, managedObjectID: nil),
            Cat(name: "Figaro", weight: 3.1, age: 2, managedObjectID: nil),
            Cat(name: "Wilfredo", weight: 2.4, age: 3, managedObjectID: nil),
            Cat(name: "Bruno", weight: 1.2, age: 1, managedObjectID: nil),
            Cat(name: "Figaro", weight: 3.1, age: 2, managedObjectID: nil),
            Cat(name: "Wilfredo", weight: 2.4, age: 3, managedObjectID: nil),
            Cat(name: "Bruno", weight: 1.2, age: 1, managedObjectID: nil),
            Cat(name: "Figaro", weight: 3.1, age: 2, managedObjectID: nil),
            Cat(name: "Wilfredo", weight: 2.4, age: 3, managedObjectID: nil),
            Cat(name: "Bruno", weight: 1.2, age: 1, managedObjectID: nil),
            Cat(name: "Figaro", weight: 3.1, age: 2, managedObjectID: nil),
            Cat(name: "Wilfredo", weight: 2.4, age: 3, managedObjectID: nil),
            Cat(name: "Bruno", weight: 1.2, age: 1, managedObjectID: nil),
            Cat(name: "Figaro", weight: 3.1, age: 2, managedObjectID: nil),
            Cat(name: "Wilfredo", weight: 2.4, age: 3, managedObjectID: nil),
            Cat(name: "Bruno", weight: 1.2, age: 1, managedObjectID: nil),
            Cat(name: "Figaro", weight: 3.1, age: 2, managedObjectID: nil),
            Cat(name: "Wilfredo", weight: 2.4, age: 3, managedObjectID: nil),
            Cat(name: "Bruno", weight: 1.2, age: 1, managedObjectID: nil),
            Cat(name: "Figaro", weight: 3.1, age: 2, managedObjectID: nil),
            Cat(name: "Wilfredo", weight: 2.4, age: 3, managedObjectID: nil),
            Cat(name: "Bruno", weight: 1.2, age: 1, managedObjectID: nil),
            Cat(name: "Figaro", weight: 3.1, age: 2, managedObjectID: nil),
            Cat(name: "Wilfredo", weight: 2.4, age: 3, managedObjectID: nil),
            Cat(name: "Bruno", weight: 1.2, age: 1, managedObjectID: nil),
            Cat(name: "Figaro", weight: 3.1, age: 2, managedObjectID: nil),
            Cat(name: "Wilfredo", weight: 2.4, age: 3, managedObjectID: nil),
            Cat(name: "Bruno", weight: 1.2, age: 1, managedObjectID: nil),
            Cat(name: "Figaro", weight: 3.1, age: 2, managedObjectID: nil),
            Cat(name: "Wilfredo", weight: 2.4, age: 3, managedObjectID: nil),
            Cat(name: "Bruno", weight: 1.2, age: 1, managedObjectID: nil),
            Cat(name: "Figaro", weight: 3.1, age: 2, managedObjectID: nil)
        ]
        let startTime = CFAbsoluteTimeGetCurrent()
        dbController.save(objects: cats)
        benchmarkTimeUpdated(CFAbsoluteTimeGetCurrent() - startTime, .save)
    }

}

