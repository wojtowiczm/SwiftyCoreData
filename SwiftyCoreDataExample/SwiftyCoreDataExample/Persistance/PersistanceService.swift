//
//  PersistanceService.swift
//  SwiftyCoreDataExample
//
//  Created by Michał Wójtowicz on 20/12/2018.
//  Copyright © 2018 Michał Wójtowicz. All rights reserved.
//

import CoreData
import SwiftyCoreData

class PersistanceService: SCDPersistanceService {
    
    private init() {}
    
    static var shared: PersistanceService {
        return PersistanceService()
    }
    
    var persistanceContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "SwiftyCoreDataExample")
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()

}

