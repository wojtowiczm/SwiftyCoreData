//
//  ReadBenchmarkMainThread.swift
//  SwiftyCoreDataExample
//
//  Created by Michał Wójtowicz on 09/01/2019.
//  Copyright © 2019 Michał Wójtowicz. All rights reserved.
//

import CoreData
import SwiftyCoreData

class ReadBenchmark: Benchmark {
    
    let dbController = SCDController<Cat, CatEntity>(with: PersistanceService.shared.persistanceContainer, operatingQueue: .main)
    
    let numberOfOperations = 100
    
    var i = 0
    
    var times: [Double] = []
    
    var oldWayTimes: [Double] = []
    
    func prepare() {
        dbController.deleteAll()
        dbController.save(objects: DataSet.readDataSet)
        print("\n***\nReading operation for dataSet with \(DataSet.readDataSet.count) elements\n Thread: Main \n")
        
        print(" Example Object: \(DataSet.base.first!)")
        print(" Number of iterations: \(numberOfOperations)\n")
        print(" Tested on \(UIDevice.modelName) iOS: \(UIDevice.current.systemVersion)\n")
        print("***\n")
    }
    
    func operate() {
        let startTime = CFAbsoluteTimeGetCurrent()
        dbController.fetchAll { cats in
            let time = CFAbsoluteTimeGetCurrent() - startTime
            let timeInMs = time * 1000
            print("Framework: SwiftyCoreData Operation: \(BenchmarkOperation.read.localizedName) Time in ms: \(timeInMs) number of objects: \(cats.count)")
            self.times.append(timeInMs)
            self.i += 1
            if self.i > self.numberOfOperations {
                self.i = 0
                print("***/n End of reading with SwiftyCoreData /n")
                print("***\n Old way reading using pure CoreData\n***\n")
                self.operateOldWay()
                return
            }
            self.operate()
        }
    }
    
    // According apple docs
    // see: https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/CoreData/FetchingObjects.html#//apple_ref/doc/uid/TP40001075-CH6-SW1
    func operateOldWay() {
        let moc = PersistanceService.shared.persistanceContainer.viewContext
        let startTime = CFAbsoluteTimeGetCurrent()
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "CatEntity")
        let fetchedCats = try? moc.fetch(fetch) as! [CatEntity]
        let cats = fetchedCats?.compactMap {
            Cat(name: $0.name! , weight: $0.weight, age: Int($0.age), managedObjectID: nil)
        } ?? []
        let time = CFAbsoluteTimeGetCurrent() - startTime
        let timeInMs = time * 1000
        print("Framework: CoreData Operation: \(BenchmarkOperation.read.localizedName) Time in ms: \(timeInMs) number of objects: \(cats.count)")
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
        print("SwiftyCoreData average read time: \(times.average)")
        print("CoreData average read time: \(oldWayTimes.average)")
    }
}

