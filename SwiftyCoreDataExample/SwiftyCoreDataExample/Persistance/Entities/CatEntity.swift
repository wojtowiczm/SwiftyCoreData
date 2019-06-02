//
//  CatEntity+CoreDataClass.swift
//  SwiftyCoreDataExample
//
//  Created by Michał Wójtowicz on 20/12/2018.
//  For license see LICENSE.txt
//
//

import CoreData
import SwiftyCoreData

@objc(CatEntity)
public class CatEntity: NSManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CatEntity> {
        return NSFetchRequest<CatEntity>(entityName: "CatEntity")
    }
    
    @NSManaged public var name: String?
    @NSManaged public var weight: Double
    @NSManaged public var age: Int64

}

extension CatEntity: SCDObjectConvertible {

    public typealias Object = Cat
    
    public func toObject() -> Cat? {
        guard let name = name else { return nil }
        
        return Cat(name: name, weight: weight, age: Int(age), managedObjectID: objectID)
    }
}
