//
//  SCDController.swift
//  SwiftyCoreData
//
//  Created by Michał Wójtowicz on 20/12/2018.
//  For license see LICENSE.txt
//

import CoreData

public struct SCDController<Object, ManagedObject>
where Object: SCDManagedObjectConvertible, ManagedObject: SCDObjectConvertible & NSManagedObject {
    
    let persistentContainer: NSPersistentContainer
    
    private var currentContext: NSManagedObjectContext!
    
    private let operatingQueue: SCDOperatingQueue
    
    /// Init for SCDControler
    ///
    /// - Parameters:
    ///   - with container: `NSPersistentContainer` for our models
    //    - operatingQueue: OperatingQueue for DataBases operations
    public init(with container: NSPersistentContainer, operatingQueue: SCDOperatingQueue = .background) {
        self.persistentContainer = container
        self.operatingQueue = operatingQueue
        self.currentContext = provideContext()
    }
    
    // MARK: - Read
    
    /// Fetches objects stored in DataBase
    ///
    /// - Parameters:
    ///   - withPredicate: `NSPredicate` - A definition of logical conditions used to constrain a search either for a fetch or for in-memory filtering.
    ///    - sortDescriptors: An immutable description of how to order a collection of objects based on a property common to all the objects.
    ///   - completion: callback after operation is completed
    public func fetchAll(
        withPredicate predicate: NSPredicate? = nil,
        sortDescriptors: [NSSortDescriptor]? = nil,
        fetchLimit: Int? = nil,
        failure: ((Error) -> Void)? = nil,
        completion: @escaping ([Object]) -> Void) {
        dispatch(onError: failure) {
            guard let fetchRequest = ManagedObject.fetchRequest() as? NSFetchRequest<ManagedObject> else {
                throw SCDError("Couldn't not perform fetchRequest for \(ManagedObject.classForCoder())")
            }
            fetchRequest.predicate = predicate
            fetchRequest.sortDescriptors = sortDescriptors
            if let limit = fetchLimit {
                fetchRequest.fetchLimit = limit
            }
            let managedObjects = try self.currentContext.fetch(fetchRequest)
            completion(managedObjects.compactMap(self.mapToObject))
        }
    }
    
    /// Fetches object stored in DataBase
    ///
    /// - Parameters:
    ///   - withId: `NSManagedObjectID` of object that will be fetched
    ///   - completion: callback after operation is completed
    public func fetch(
        withId id: NSManagedObjectID,
        failure: ((Error) -> Void)? = nil,
        completion: @escaping ((Object) -> Void)) {
        dispatch(onError: failure) {
            guard let result = try self.currentContext.existingObject(with: id) as? ManagedObject,
                let object = self.mapToObject(result)
                else {
                    throw SCDError("Fetched NSManagedObject is not SCDObjectConvertible")
            }
            completion(object)
        }
    }
    
    public func fetchFirst(
        withPredicate predicate: NSPredicate? = nil,
        failure: ((Error) -> Void)? = nil,
        completion: @escaping (Object?) -> Void) {
        fetchAll(withPredicate: predicate, fetchLimit: 1) { completion($0.first) }
    }
    
    /// Counts obejects stored in DataBase
    ///
    /// - Parameters:
    ///   - withPredicate: `NSPredicate` - A definition of logical conditions used to constrain a search either for a fetch or for in-memory filtering.
    ///   - completion: callback after operation is completed
    public func countAll(
        withPredicate predicate: NSPredicate? = nil,
        failure: ((Error) -> Void)? = nil,
        completion: @escaping (Int) -> Void) {
        dispatch(onError: failure) {
            guard let fetchRequest = ManagedObject.fetchRequest() as? NSFetchRequest<ManagedObject> else {
                throw SCDError("Couldn't not perform fetchRequest for \(ManagedObject.classForCoder())")
            }
            fetchRequest.predicate = predicate
            let objectsCount = try self.currentContext.count(for: fetchRequest)
            completion(objectsCount)
        }
    }
    
    // MARK: - Write
    
    /// Saves objects to DataBase
    ///
    /// - Parameters:
    ///   - objects: Collections of objects that will be saved in DataBase
    ///   - completion: callback after operation is completed
    public func save(
        objects: [Object],
        failure: ((Error) -> Void)? = nil,
        completion: @escaping () -> Void = {}) {
        dispatch(onError: failure) {
            try objects.forEach {
                let entity = $0.put(in: self.currentContext)
                try self.saveContext()
                $0.managedObjectID = entity.objectID
            }
            completion()
        }
    }
    
    /// Saves obeject to DataBase
    ///
    /// - Parameters:
    ///   - object: Object that will be saved in DataBase
    ///   - completion: callback after operation is completed
    public func save(
        _ object: Object,
        failure: ((Error) -> Void)? = nil,
        completion: @escaping () -> Void = {}) {
        dispatch(onError: failure) {
            let entity = object.put(in: self.currentContext)
            try self.saveContext()
            object.managedObjectID = entity.objectID
            completion()
        }
    }
    
    // MARK: -  Delete
    
    /// Deletes every object that matches exist in database
    ///
    /// - Parameters:
    ///   - withPredicate: `NSPredicate` - A definition of logical conditions used to constrain a search either for a fetch or for in-memory filtering.
    ///   - completion: callback after operation is completed
    public func deleteAll(
        withPredicate predicate: NSPredicate? = nil,
        failure: ((Error) -> Void)? = nil,
        completion: @escaping () -> Void = {}) {
        dispatch(onError: failure) {
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = ManagedObject.fetchRequest()
            fetchRequest.predicate = predicate
            let batchDelete = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            try self.currentContext.execute(batchDelete)
            completion()
        }
    }
    
    /// Deletes object that exist in database
    ///
    /// - Parameters:
    ///   - object: instance that will be deleted
    ///   - completion: callback after operation is completed
    public func delete(
        _ object: Object,
        failure: ((Error) -> Void)? = nil,
        completion: @escaping () -> Void = {}) {
        guard let id = object.managedObjectID else { return }
        dispatch(onError: failure) {
            guard let object = try? self.currentContext.existingObject(with: id) else { return }
            self.currentContext.delete(object)
            try self.saveContext()
            completion()
        }
    }
    
    // MARK: - Update
    
    /// Replaces existing object with new value
    ///
    /// - Parameters:
    ///   - object: object to update
    ///   - with: New object
    ///   - completion: callback after operation is completed
    public func update(
        _ object: Object,
        failure: ((Error) -> Void)? = nil,
        completion: @escaping () -> Void = {}) {
        delete(object) {
            self.save(object, completion: completion)
        }
    }
}

// MARK: - Mapping helpers

extension SCDController {
    
    private func mapToObject(_ managedObject: ManagedObject) -> Object? {
        let object = managedObject.toObject() as? Object
        object?.managedObjectID = managedObject.objectID
        return object
    }
}

// MARK: - Queue Helpers

extension SCDController {
    
    // Benchmarks showed that using `perform` on Main Thread significally descreased performance
    // I.E: From 20 ms to 40 ms
    // But we need it while operating on background thread
    private func dispatch(onError failure: ((Error) -> Void)? = nil, _ operation: @escaping () throws -> Void) {
        func throwable() {
            do {
                try operation()
            } catch {
                failure?(error)
            }
        }
        switch operatingQueue {
        case .main: throwable()
        case .background: return currentContext.perform(throwable)
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
    
    private func saveContext() throws {
        guard currentContext.hasChanges else { return }
        
        do {
            try currentContext.save()
        } catch {
            throw error
        }
    }
}
