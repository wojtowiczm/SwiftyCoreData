//
//  TestPersistanceService.swift
//  SwiftyCoreDataTests
//
//  Created by KISS digital on 21/06/2019.
//  Copyright © 2019 Michał Wójtowicz. All rights reserved.
//

import CoreData
import SwiftyCoreData

class TestPersistanceService {
    
    private init() {}
    
    static var shared: TestPersistanceService {
        return TestPersistanceService()
    }
    
    var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "SwiftyCoreDataExample")
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
}

