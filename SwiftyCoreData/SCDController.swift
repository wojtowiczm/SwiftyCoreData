//
//  SCDController.swift
//  SwiftyCoreData
//
//  Created by Michał Wójtowicz on 20/12/2018.
//  Copyright © 2018 Michał Wójtowicz. All rights reserved.
//

import CoreData

public struct SCDController<Object, ManagedObject>
where Object: SCDManagedObjectConvertible, ManagedObject: SCDObjectConvertible, ManagedObject: NSManagedObject {
    
    let persistentContainer: NSPersistentContainer
    
    private var currentContext: NSManagedObjectContext!
    
    public init(with container: NSPersistentContainer, operatingQueue: SCDOperatingQueue = .background) {
        self.persistentContainer = container
        self.currentContext = provideContext(for: operatingQueue)
    }
    
    public func fetchAll(withPredicate predicate: NSPredicate? = nil, completion: @escaping (([Object]?) -> Void)) {
        currentContext.perform {
            guard let fetchRequest = ManagedObject.fetchRequest() as? NSFetchRequest<ManagedObject> else {
                completion(nil)
                return
            }
            do {
                let managedObjects = try self.currentContext.fetch(fetchRequest)
                completion(managedObjects.compactMap { $0.toObject() as? Object})
            } catch {
                print("SDCError \(error.localizedDescription)")
                completion(nil)
            }
        }
    }
    
    public func fetch(withId id: NSManagedObjectID, completion: ((Object?) -> Void)) {
        do {
            let result = try currentContext.existingObject(with: id) as! ManagedObject
            if let object = result.toObject() as? Object {
                completion(object)
            }
        } catch {
            print("SDCError \(error.localizedDescription)")
            completion(nil)
        }
    }
    
    public func deleteAll() {
        guard let fetchRequest: NSFetchRequest<ManagedObject> = ManagedObject.fetchRequest() as? NSFetchRequest<ManagedObject> else { return }
        do {
            let objects = try currentContext.fetch(fetchRequest)
            objects.forEach { currentContext.delete($0) }
            saveContext()
        } catch {
            print("SDCError \(error.localizedDescription)")
        }
    }
    
    public func deleteObject(withId id: NSManagedObjectID) {
        do {
            let object = try currentContext.existingObject(with: id)
            currentContext.delete(object)
            saveContext()
        } catch {
            print("SDCError \(error.localizedDescription)")
        }
    }
    
    public func save(objects: [Object]) {
        objects.forEach { $0.put(in: currentContext) }
        saveContext()
    }
    
    public func save(object: Object) {
        object.put(in: currentContext)
        saveContext()
    }
    
    public func update(withId id: NSManagedObjectID, to newObject: Object) {
        deleteObject(withId: id)
        save(object: newObject)
    }
    
}

// MARK: - Helper methods

extension SCDController {
    
    private func provideContext(for operatingQueue: SCDOperatingQueue) -> NSManagedObjectContext {
        switch operatingQueue {
        case .main: return persistentContainer.viewContext
        case .background: return persistentContainer.newBackgroundContext()
        }
    }
    
    private func saveContext() {
        guard currentContext.hasChanges else { return }
        
        do {
            try currentContext.save()
        } catch {
            print("SCDError: \(error.localizedDescription)")
        }
    }
}
