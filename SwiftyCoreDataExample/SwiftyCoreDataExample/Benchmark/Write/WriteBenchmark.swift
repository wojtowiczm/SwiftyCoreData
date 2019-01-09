//
//  Write.swift
//  SwiftyCoreDataExample
//
//  Created by Michał Wójtowicz on 09/01/2019.
//  Copyright © 2019 Michał Wójtowicz. All rights reserved.
//

import SwiftyCoreData
import CoreData

class WriteBenchmark: Benchmark {
    
    let dbController = SCDController<Cat, CatEntity>(with: PersistanceService.shared.persistanceContainer, operatingQueue: .main)
    
    let numberOfOperations = 100
    
    var i = 0
    
    var times: [Double] = []
    
    var oldWayTimes: [Double] = []
    
    func prepare() {
        dbController.deleteAll()
        print("\n***\nSaving operation for dataSet with \(DataSet.writeDataSet.count) elements")
        print("Thread: Main")
        
        print(" Example Object: \(DataSet.base.first!)")
        print(" Number of iterations: \(numberOfOperations)\n")
        print(" Tested on \(UIDevice.modelName) iOS: \(UIDevice.current.systemVersion)\n")
        print("***\n")
    }
    
    func operate() {
        let dataSet = DataSet.writeDataSet
        let startTime = CFAbsoluteTimeGetCurrent()
        dbController.save(objects: dataSet)
        let time = CFAbsoluteTimeGetCurrent() - startTime
        let timeInMs = time * 1000
        print("Framework: SwiftyCoreData Operation: \(BenchmarkOperation.write.localizedName) Time in ms: \(timeInMs) number of objects: \(dataSet.count)")
        self.times.append(timeInMs)
        self.i += 1
        if self.i > self.numberOfOperations {
            self.i = 0
            print("***/n End of writhing with SwiftyCoreData /n")
            print("***\n Old way writing using pure CoreData\n***\n")
            self.operateOldWay()
            return
        }
        self.operate()
        
    }
    
    // Acording apple docs
    // see: https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/CoreData/CreatingObjects.html
    
    func operateOldWay() {
        let dataSet = DataSet.writeDataSet
        let startTime = CFAbsoluteTimeGetCurrent()
        let moc = PersistanceService.shared.persistanceContainer.viewContext
        dataSet.forEach {
            let mo = NSEntityDescription.insertNewObject(forEntityName: "CatEntity", into: moc) as! CatEntity
            mo.age = Int64($0.age)
            mo.name = $0.name
            mo.weight = $0.weight
        }
        do {
            try moc.save()
        } catch {}
        
        let time = CFAbsoluteTimeGetCurrent() - startTime
        let timeInMs = time * 1000
        print("Framework: CoreData Operation: \(BenchmarkOperation.write.localizedName) Time in ms: \(timeInMs) number of objects: \(dataSet.count)")
        self.oldWayTimes.append(timeInMs)
        self.i += 1
        if self.i > self.numberOfOperations {
            print("***/n End of reading with pure CoreData /n")
            self.finalize()
            return
        }
        self.operateOldWay()
    }
    
    func finalize() {
        print()
        print("Finalized benchmark")
        print("SwiftyCoreData average write time: \(times.average)")
        print("CoreData average write time: \(oldWayTimes.average)")
        
    }
    
}
