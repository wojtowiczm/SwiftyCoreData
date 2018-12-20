//
//  SCDManagedObjectConvertible.swift
//  SwiftyCoreData
//
//  Created by Michał Wójtowicz on 20/12/2018.
//  Copyright © 2018 Michał Wójtowicz. All rights reserved.
//

import CoreData

protocol SCDManagedObjectConvertible {
    func toManagedObject(in context: NSManagedObjectContext)
}
