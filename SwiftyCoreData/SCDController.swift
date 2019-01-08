//
//  SCDController.swift
//  SwiftyCoreData
//
//  Created by Michał Wójtowicz on 20/12/2018.
//  Copyright © 2018 Michał Wójtowicz. All rights reserved.
//

import CoreData

public struct SCDController<Object, ManagedObject>
where Object: SCDManagedObjectConvertible, ManagedObject: SCDObjectConvertible & NSManagedObject {
    
    let persistentContainer: NSPersistentContainer
    
    private var currentContext: NSManagedObjectContext!
    
    public init(with container: NSPersistentContainer, operatingQueue: SCDOperatingQueue = .background) {
        self.persistentContainer = container
        self.currentContext = provideContext(for: operatingQueue)
    }
    
    public func fetchAll(withPredicate predicate: NSPredicate? = nil, completion: @escaping (([Object]) -> Void)) {
        currentContext.perform {
            guard let fetchRequest = ManagedObject.fetchRequest() as? NSFetchRequest<ManagedObject> else {
                self.printError(message: "Couldn't not perform fetchRequest for \(ManagedObject.classForCoder())")
                completion([])
                return
            }
            fetchRequest.predicate = predicate
            do {
                let managedObjects = try self.currentContext.fetch(fetchRequest)
                completion(managedObjects.compactMap { $0.toObject() as? Object})
            } catch {
                completion([])
                self.printError(message: error.localizedDescription)
            }
        }
    }
    
    public func fetch(withId id: NSManagedObjectID, completion: @escaping ((Object?) -> Void)) {
        currentContext.perform {
            do {
                guard let result = try self.currentContext.existingObject(with: id) as? ManagedObject else {
                    self.printError(message: "NSManagedObject is not SCDObjectConvertible")
                    completion(nil)
                    return
                }
                completion(result.toObject() as? Object)
            } catch {
                self.printError(message: error.localizedDescription)
                completion(nil)
            }
        }
    }
    
    public func deleteAll(withPredicate predicate: NSPredicate? = nil) {
        guard let fetchRequest: NSFetchRequest<ManagedObject> = ManagedObject.fetchRequest() as? NSFetchRequest<ManagedObject> else { return }
        fetchRequest.predicate = predicate
        do {
            let objects = try currentContext.fetch(fetchRequest)
            objects.forEach { currentContext.delete($0) }
            saveContext()
        } catch {
            printError(message: error.localizedDescription)
        }
    }
    
    public func deleteObject(withId id: NSManagedObjectID) {
        do {
            let object = try currentContext.existingObject(with: id)
            currentContext.delete(object)
            saveContext()
        } catch {
            printError(message: error.localizedDescription)
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
            printError(message: error.localizedDescription)
        }
    }
    
    private func printError(message: String) {
        print("""
            *** SwiftyCoreData error:
            message: \(message)"
            ***
            """)
    }
}
