//
//  PersistanceService.swift
//  SwiftyCoreDataExample
//
//  Created by Michał Wójtowicz on 20/12/2018.
//  For license see LICENSE.txt
//

import CoreData
import SwiftyCoreData

class PersistanceService {
    
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

