//
//  SCDObjectConvertible.swift
//  SwiftyCoreData
//
//  Created by Michał Wójtowicz on 20/12/2018.
//  For license see LICENSE.txt
//

import Foundation

public protocol SCDObjectConvertible: class {
    
    /// Associated Type of App Model
    associatedtype Object
    
    /// Method that implements mapping logic between `Object` and `NSManagedObject`
    ///
    /// - Returns: Object that will be uses inside app
    func toObject() -> Object?
}
