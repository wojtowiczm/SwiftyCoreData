//
//  TestModel.swift
//  SwiftyCoreDataTests
//
//  Created by KISS digital on 21/06/2019.
//  Copyright © 2019 Michał Wójtowicz. All rights reserved.
//

import CoreData
import SwiftyCoreData

struct TestModel: Codable {
    
    let string: String
    let double: Double
    let int: Int
    let date: Date
    let data: Data
}

extension TestModel: SCDManagedObjectConvertible {
  
    typealias ManagedObject = TestManagedObject
    
    func put(in context: NSManagedObjectContext) -> TestManagedObject {
        let entitity = TestManagedObject(context: context)
        entitity.string = self.string
        entitity.double = self.double
        entitity.int = self.int
        entitity.date = self.date as NSDate
        entitity.data = self.data as NSData
        return entitity
    }
    
    func obtainedObjectID(_ id: NSManagedObjectID) {
        
    }
}
