//
//  ViewModel.swift
//  SwiftyCoreDataExample
//
//  Created by Michał Wójtowicz on 20/12/2018.
//  For license see LICENSE.txt
//

import CoreData
import SwiftyCoreData

class CatsViewModel {
    
    var catsUpdated: (([Cat]) -> Void)!
    
    var benchmarkTimeUpdated: ((Double, BenchmarkOperation) -> Void)!
    
    private let dbController = SCDController<Cat, CatEntity>(with: PersistanceService.shared.persistanceContainer, operatingQueue: .main)
    
    func loadCats() {
        let startTime = CFAbsoluteTimeGetCurrent()
        dbController.fetchAll { [unowned self] in
            self.benchmarkTimeUpdated(CFAbsoluteTimeGetCurrent() - startTime, .read)
            self.catsUpdated($0)
        }
    }
    
    func loadOldWay() {
        let startTime = CFAbsoluteTimeGetCurrent()
        let moc = PersistanceService.shared.persistanceContainer.viewContext
        let employeesFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "CatEntity")
        
        do {
            let fetchedCats = try moc.fetch(employeesFetch) as! [CatEntity]
            
            let cats = fetchedCats.compactMap {
                Cat(name: $0.name! , weight: $0.weight, age: Int($0.age), managedObjectID: $0.objectID)
            }
            benchmarkTimeUpdated(CFAbsoluteTimeGetCurrent() - startTime, .read)
            catsUpdated(cats)
        } catch {
            fatalError("Failed to fetch employees: \(error)")
        }
    }
    
    func deleteCats(_ cats: [Cat]) {
        let startTime = CFAbsoluteTimeGetCurrent()
        cats.forEach { dbController.delete($0, completion: {
            self.benchmarkTimeUpdated(CFAbsoluteTimeGetCurrent() - startTime, .delete)
        }) }
        
    }
    
    func saveCats() {
        let startTime = CFAbsoluteTimeGetCurrent()
        dbController.save(objects: DataSet.base)
        benchmarkTimeUpdated(CFAbsoluteTimeGetCurrent() - startTime, .write)
    }

}

