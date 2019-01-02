//
//  SCDWorker.swift
//  SwiftyCoreData
//
//  Created by Michał Wójtowicz on 20/12/2018.
//  Copyright © 2018 Michał Wójtowicz. All rights reserved.
//

import CoreData

public struct SCDWorker<Object, ManagedObject>
where Object: SCDManagedObjectConvertible, ManagedObject: SCDObjectConvertible, ManagedObject: NSManagedObject {
    
    let persistanceService: SCDPersistanceService
    
    public init(persistanceService: SCDPersistanceService) {
        self.persistanceService = persistanceService
    }
    
    public func fetchAllObjects(completion: @escaping (([Object]?) -> Void)) {
        persistanceService.context.perform {
            guard let fetchRequest = ManagedObject.fetchRequest() as? NSFetchRequest<ManagedObject> else {
                completion(nil)
                return
            }
            do {
                let managedObjects = try self.persistanceService.context.fetch(fetchRequest)
                completion(managedObjects.compactMap { $0.toObject() as? Object})
            } catch {
                print("SDCError \(error.localizedDescription)")
                completion(nil)
            }
        }
    }
    
    public func fetchObject(with id: NSManagedObjectID, completion: ((Object?) -> Void)) {
        do {
            let result = try persistanceService.context.existingObject(with: id) as! ManagedObject
            if let object = result.toObject() as? Object {
                completion(object)
            }
        } catch {
            print("SDCError \(error.localizedDescription)")
            completion(nil)
        }
    }
    
    public func deleteObjects() {
        guard let fetchRequest: NSFetchRequest<ManagedObject> = ManagedObject.fetchRequest() as? NSFetchRequest<ManagedObject> else { return }
        do {
            let objects = try persistanceService.context.fetch(fetchRequest)
            objects.forEach { persistanceService.context.delete($0) }
            persistanceService.saveContext()
        } catch {
            print("SDCError \(error.localizedDescription)")
        }
    }
    
    public func deleteObject(withID id: NSManagedObjectID) {
        do {
            let object = try persistanceService.context.existingObject(with: id)
            persistanceService.context.delete(object)
            persistanceService.saveContext()
        } catch {
            print("SDCError \(error.localizedDescription)")
        }
    }
    
    public func save(objects: [Object]) {
        objects.forEach { $0.put(in: persistanceService.context) }
        persistanceService.saveContext()
    }
    
    public func save(object: Object) {
        object.put(in: persistanceService.context)
        persistanceService.saveContext()
    }
}
