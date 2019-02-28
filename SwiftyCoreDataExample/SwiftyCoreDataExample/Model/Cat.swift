//
//  Cat.swift
//  SwiftyCoreDataExample
//
//  Created by Michał Wójtowicz on 20/12/2018.
//  Copyright © 2018 Michał Wójtowicz. All rights reserved.
//

import CoreData
import SwiftyCoreData

public struct Cat {
    let name: String
    let weight: Double
    let age: Int
    
    var managedObjectID: NSManagedObjectID?
}

extension Cat: SCDManagedObjectConvertible {
    
    public typealias ManagedObject = CatEntity
    
    public func put(in context: NSManagedObjectContext) -> CatEntity {
        let catEntity = CatEntity(context: context)
        catEntity.name = self.name
        catEntity.weight = weight
        catEntity.age = Int64(age)
        return catEntity
    }
}


