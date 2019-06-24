//
//  SCDManagedObjectConvertible.swift
//  SwiftyCoreData
//
//  Created by Michał Wójtowicz on 20/12/2018.
//  For license see LICENSE.txt
//

import CoreData

public protocol SCDManagedObjectConvertible {
    
    /// Associated Type of DataBase Model
    associatedtype ManagedObject: NSManagedObject
    
    /// Method that implements mapping logic between `NSManagedObject` and `Object`
    ///
    /// - Parameter context: An object space that you use to manipulate and track changes to managed objects.
    /// - Returns: Object that will stored in DataBase
    @discardableResult
    func put(in context: NSManagedObjectContext) -> ManagedObject
    
    /// Callback method called when `NSManagedObjectID` is obtained or updated
    /// In CoreData `NSManagedObjectID` is updated when it is saved/updated
    /// - Parameter id: Fresh `NSManagedObjectID` for object
    func obtainedObjectID(_ id: NSManagedObjectID)
}

extension SCDManagedObjectConvertible {
    func obtainedObjectID(_ id: NSManagedObjectID) {}
}
