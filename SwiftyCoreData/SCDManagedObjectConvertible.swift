//
//  SCDManagedObjectConvertible.swift
//  SwiftyCoreData
//
//  Created by Michał Wójtowicz on 20/12/2018.
//  For license see LICENSE.txt
//

import CoreData

public protocol SCDManagedObjectConvertible: class {
    
    /// ID of paired ManagedObject
    /// Neeeded for delete & update operation
    var managedObjectID: NSManagedObjectID? { get set }
    
    /// Associated Type of DataBase Model
    associatedtype ManagedObject: NSManagedObject
    
    /// Method that implements mapping logic between `NSManagedObject` and `Object`
    ///
    /// - Parameter context: An object space that you use to manipulate and track changes to managed objects.
    /// - Returns: Object that will stored in DataBase
    @discardableResult
    func put(in context: NSManagedObjectContext) -> ManagedObject
}
