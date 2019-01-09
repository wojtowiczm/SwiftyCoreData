//
//  Benchmark.swift
//  SwiftyCoreDataExample
//
//  Created by Michał Wójtowicz on 09/01/2019.
//  Copyright © 2019 Michał Wójtowicz. All rights reserved.
//

import Foundation
import SwiftyCoreData
import CoreData

protocol Benchmark {
    func prepare()
    func operate()
    func operateOldWay()
    func finalize()
}

class ReadBenchmarkMainThread: Benchmark {
    
    let dbController = SCDController<Cat, CatEntity>(with: PersistanceService.shared.persistanceContainer, operatingQueue: .main)
    
    let numberOfOperations = 100
    
    var i = 0
    
    var times: [Double] = []
    
    var oldWayTimes: [Double] = []
    
    func prepare() {
        dbController.deleteAll()
        dbController.save(objects: DataSet.oneHoundredThousandCats)
        print("\n***\nReading operation for dataSet with \(DataSet.oneHoundredThousandCats.count) elements\n Thread: Main \n")
        
        print(" Example Object: \(DataSet.base.first!)")
        print(" Number of iterations: \(numberOfOperations)\n")
        print(" Tested on iPhone 7 iOS: 12\n")
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
    
    func operateOldWay() {
        let startTime = CFAbsoluteTimeGetCurrent()
        let moc = PersistanceService.shared.persistanceContainer.viewContext
        let employeesFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "CatEntity")
        moc.perform {
            do {
                let fetchedCats = try moc.fetch(employeesFetch) as! [CatEntity]
                
                let cats = fetchedCats.compactMap {
                    Cat(name: $0.name! , weight: $0.weight, age: Int($0.age), managedObjectID: $0.objectID)
                }
                
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
            } catch {
                //fatalError("Failed to fetch employees: \(error)")
            }
        }
    }
    
    func finalize() {
        print()
        print("Finalized benchmark")
        print("SwiftyCoreData average read time: \(times.average)")
        print("CoreData average read time: \(oldWayTimes.average)")
        
    }
    
}

class ReadBenchmarkBackgroundThread: Benchmark {
    
    let dbController = SCDController<Cat, CatEntity>(with: PersistanceService.shared.persistanceContainer, operatingQueue: .background)
    
    let numberOfOperations = 100
    
    var i = 0
    
    var times: [Double] = []
    
    var oldWayTimes: [Double] = []
    
    func prepare() {
        dbController.deleteAll()
        dbController.save(objects: DataSet.oneHoundredThousandCats)
        print("\n***\nReading operation for dataSet with \(DataSet.oneHoundredThousandCats.count) elements\n Thread: Background \n")
        
        print(" Example Object: \(DataSet.base.first!)")
        print(" Number of iterations: \(numberOfOperations)\n")
        print(" Tested on iPhone 7 iOS: 12\n")
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
    
    func operateOldWay() {
        let startTime = CFAbsoluteTimeGetCurrent()
        let moc = PersistanceService.shared.persistanceContainer.newBackgroundContext()
        let employeesFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "CatEntity")
        moc.perform {
            do {
                let fetchedCats = try moc.fetch(employeesFetch) as! [CatEntity]
                
                let cats = fetchedCats.compactMap {
                    Cat(name: $0.name! , weight: $0.weight, age: Int($0.age), managedObjectID: $0.objectID)
                }
                
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
            } catch {
                //fatalError("Failed to fetch employees: \(error)")
            }
        }
    }
    
    func finalize() {
        print()
        print("Finalized benchmark")
        print("SwiftyCoreData average read time: \(times.average)")
        print("CoreData average read time: \(oldWayTimes.average)")
        
        print("\nCONCLUSION\n")
    }
    
}

