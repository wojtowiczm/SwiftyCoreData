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
    
    private let operatingQueue: SCDOperatingQueue
    
    public init(with container: NSPersistentContainer, operatingQueue: SCDOperatingQueue = .background) {
        self.persistentContainer = container
        self.operatingQueue = operatingQueue
        self.currentContext = provideContext()
    }
    
    // MARK: - Read
    
    public func fetchAll(withPredicate predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil, completion: @escaping (([Object]) -> Void)) {
        dispatch {
            guard let fetchRequest = ManagedObject.fetchRequest() as? NSFetchRequest<ManagedObject> else {
                self.printError(message: "Couldn't not perform fetchRequest for \(ManagedObject.classForCoder())")
                completion([])
                return
            }
            fetchRequest.predicate = predicate
            fetchRequest.sortDescriptors = sortDescriptors
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
        dispatch {
            do {
                guard let result = try self.currentContext.existingObject(with: id) as? ManagedObject else {
                    self.printError(message: "Fetched NSManagedObject is not SCDObjectConvertible")
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
    
    public func countAll(withPredicate predicate: NSPredicate? = nil, completion: @escaping (Int) -> Void) {
        dispatch {
            guard let fetchRequest = ManagedObject.fetchRequest() as? NSFetchRequest<ManagedObject> else {
                self.printError(message: "Couldn't not perform fetchRequest for \(ManagedObject.classForCoder())")
                completion(0)
                return
            }
            fetchRequest.predicate = predicate
            do {
                let objectsCount = try self.currentContext.count(for: fetchRequest)
                completion(objectsCount)
            } catch {
                completion(0)
                self.printError(message: error.localizedDescription)
            }
        }
    }
    
    // MARK: - Write
    
    public func save(objects: [Object]) {
        dispatch {
            objects.forEach { $0.put(in: self.currentContext) }
            self.saveContext()
        }
    }
    
    public func save(object: Object) {
        dispatch {
            object.put(in: self.currentContext)
            self.saveContext()
        }
    }
    
    // MARK: -  Delete
    
    public func deleteAll(withPredicate predicate: NSPredicate? = nil) {
        dispatch {
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = ManagedObject.fetchRequest()
            fetchRequest.predicate = predicate
            let batchDelete = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            do {
                try self.currentContext.execute(batchDelete)
            } catch {
                self.printError(message: error.localizedDescription)
            }
        }
    }
    
    public func deleteObject(withId id: NSManagedObjectID) {
        dispatch {
            do {
                let object = try self.currentContext.existingObject(with: id)
                self.currentContext.delete(object)
                self.saveContext()
            } catch {
                self.printError(message: error.localizedDescription)
            }
        }
    }
    
    // MARK: - Update
    
    public func replace(objectWithId id: NSManagedObjectID, to newObject: Object) {
        deleteObject(withId: id)
        save(object: newObject)
    }
}

// MARK: - Queue Helpers

extension SCDController {
    
    // Benchmarks showed that using `perform` on Main Thread significally descreased performance
    // I.E: From 20 ms to 40 ms
    // But we need it while operating on background thread
    private func dispatch(_ operation: @escaping () -> Void) {
        switch operatingQueue {
        case .main: operation()
        case .background: return currentContext.perform(operation)
        }
    }
}

// MARK: - CoreData Helpers

extension SCDController {
    private func provideContext() -> NSManagedObjectContext {
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
}

// MARK: - Error Logging

extension SCDController {
    private func printError(message: String) {
        print("""
            *** SwiftyCoreData error:
            message: \(message)"
            ***
            """)
    }
}
