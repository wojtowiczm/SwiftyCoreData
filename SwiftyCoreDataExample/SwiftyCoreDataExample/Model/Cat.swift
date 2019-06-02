//
//  Cat.swift
//  SwiftyCoreDataExample
//
//  Created by Michał Wójtowicz on 20/12/2018.
//  For license see LICENSE.txt
//

import CoreData
import SwiftyCoreData

public final class Cat {
    let name: String
    let weight: Double
    let age: Int
    
    var managedObjectID: NSManagedObjectID?
    
    init(name: String, weight: Double, age: Int, managedObjectID: NSManagedObjectID? = nil) {
        self.name = name
        self.weight = weight
        self.age = age
        self.managedObjectID = managedObjectID
    }
}

extension Cat: SCDManagedObjectConvertible {
    
    public func obtainedObjectID(_ id: NSManagedObjectID) {
        self.managedObjectID = id
    }
    
    public typealias ManagedObject = CatEntity
    
    public func put(in context: NSManagedObjectContext) -> CatEntity {
        let catEntity = CatEntity(context: context)
        catEntity.name = self.name
        catEntity.weight = weight
        catEntity.age = Int64(age)
        return catEntity
    }
}


