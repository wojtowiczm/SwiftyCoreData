//
//  SCDPersistanceService.swift
//  SwiftyCoreData
//
//  Created by Michał Wójtowicz on 20/12/2018.
//  Copyright © 2018 Michał Wójtowicz. All rights reserved.
//

import CoreData

public protocol SCDPersistanceService {
   
    var persistanceContainer: NSPersistentContainer { get set }
}

public extension SCDPersistanceService {
    
    var context: NSManagedObjectContext {
        return persistanceContainer.viewContext
    }
    
    func saveContext() {
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch {
            print("SCDError: \(error.localizedDescription)")
        }
    }
}
