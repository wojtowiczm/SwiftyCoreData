//
//  ViewModel.swift
//  SwiftyCoreDataExample
//
//  Created by Michał Wójtowicz on 20/12/2018.
//  Copyright © 2018 Michał Wójtowicz. All rights reserved.
//

import CoreData
import SwiftyCoreData

class ViewModel {
    
    let catsDataBaseWorker = SCDWorker<Cat, CatEntity>(persistanceService: PersistanceService.shared)
    
    func loadCats(completion: @escaping ([Cat]) -> Void) {
        catsDataBaseWorker.fetchAllObjects {
            guard let cats = $0 else {
                completion([])
                return
            }
            completion(cats)
        }
    }
    
    func deleteCat(with id: NSManagedObjectID) {
        catsDataBaseWorker.deleteObject(withID: id)
    }
    
    func restoreData() {
        let cats = [
            Cat(name: "Wilfredo", weight: 2.4, age: 3, managedObjectID: nil),
            Cat(name: "Bruno", weight: 1.2, age: 1, managedObjectID: nil),
            Cat(name: "Figaro", weight: 3.1, age: 2, managedObjectID: nil)
        ]
        catsDataBaseWorker.deleteObjects()
        catsDataBaseWorker.save(objects: cats)
    }
}

