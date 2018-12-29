//
//  ViewModel.swift
//  SwiftyCoreDataExample
//
//  Created by Michał Wójtowicz on 20/12/2018.
//  Copyright © 2018 Michał Wójtowicz. All rights reserved.
//

import CoreData
import SwiftyCoreData

class CatsViewModel {
    
    var catsChanged: (([Cat]) -> Void)?
    
    private let catsDataBaseWorker = SCDWorker<Cat, CatEntity>(persistanceService: PersistanceService.shared)
    
    func loadCats() {
        catsDataBaseWorker.fetchAll { [weak self] in
            self?.catsChanged?($0 ?? [])
        }
    }
    
    func deleteCats() {
        catsDataBaseWorker.deleteAll()
    }
    
    func deleteCat(with id: NSManagedObjectID) {
        catsDataBaseWorker.deleteObject(withId: id)
    }
    
    func restoreCats() {
        let cats = [
            Cat(name: "Wilfredo", weight: 2.4, age: 3, managedObjectID: nil),
            Cat(name: "Bruno", weight: 1.2, age: 1, managedObjectID: nil),
            Cat(name: "Figaro", weight: 3.1, age: 2, managedObjectID: nil)
        ]
        catsDataBaseWorker.deleteAll()
        catsDataBaseWorker.save(objects: cats)
        loadCats()
    }
}

