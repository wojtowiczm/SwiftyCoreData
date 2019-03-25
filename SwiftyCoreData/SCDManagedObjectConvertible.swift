//
//  SCDManagedObjectConvertible.swift
//  SwiftyCoreData
//
//  Created by Michał Wójtowicz on 20/12/2018.
//  Copyright © 2018 Michał Wójtowicz. All rights reserved.
//

import CoreData

public protocol SCDManagedObjectConvertible {
    
    associatedtype ManagedObject: NSManagedObject
    
    @discardableResult
    func put(in context: NSManagedObjectContext) -> ManagedObject
    
    func obtainedObjectID(_ id: NSManagedObjectID)
}
