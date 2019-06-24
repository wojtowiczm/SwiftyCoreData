//
//  TestManagedObject+CoreDataClass.swift
//  
//
//  Created by KISS digital on 21/06/2019.
//
//

import Foundation
import SwiftyCoreData
import CoreData

@objc(TestManagedObject)
public class TestManagedObject: NSManagedObject, Codable {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<TestManagedObject> {
        return NSFetchRequest<TestManagedObject>(entityName: "TestManagedObject")
    }
    
    @NSManaged public var string: String?
    @NSManaged public var double: Double
    @NSManaged public var int: Int32
    @NSManaged public var date: NSDate?
    @NSManaged public var data: NSData?
}

extension TestManagedObject: SCDObjectConvertible {
    
    typealias Object = TestModel
    
    func toObject() -> TestModel? {
        return TestModel(string: string, double: double, int: int, date: date as Date, data: data as Data)
    }
}
