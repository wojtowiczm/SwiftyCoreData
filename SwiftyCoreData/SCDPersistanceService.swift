//
//  SCDPersistanceService.swift
//  SwiftyCoreData
//
//  Created by Michał Wójtowicz on 20/12/2018.
//  Copyright © 2018 Michał Wójtowicz. All rights reserved.
//

import CoreData

public protocol SCDPersistanceService {
    var context: NSManagedObjectContext { get set }
    var persistanceContainer: NSPersistentContainer { get set }
    func saveContext()
}
