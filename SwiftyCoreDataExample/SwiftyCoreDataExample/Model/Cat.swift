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
    
    public func toManagedObject(in context: NSManagedObjectContext) {
        let catEntity = CatEntity(context: context)
        catEntity.name = self.name
        catEntity.weight = weight
        catEntity.age = Int16(age)
    }
}


