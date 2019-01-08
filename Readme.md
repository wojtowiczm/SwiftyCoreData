# SwiftyCoreData

SwiftyCoreData is a lightweight libliary written in Swift. Main purpose is to make using CoreData easier without necessary template code code. This libliary uses power of Swift Generics and Protocols. 
## Advantages
* Thread Safety
* Immutable 
* No shared state
* No template code

## Installation (Alpha)

SwiftyCoreData is currently avaliable on CocoaPods for alpha tests. Just type in your podfile:

```bash

pod 'SwiftyCoreData', :git => 'https://github.com/wojtowiczm/SwiftyCoreData.git', :branch => 'develop'

```


## Usage
After implementing all steps presented in guide our logic code will look like this:

```swift
import SwiftyCoreData

class ViewModel {

    // Create SCDController with given ObjectType and ManagedObjectType and NSPersistentContainer
    let dbController = SCDController<Object, ManagedObject>(with: persistanceContainer)

    func loadCache() {
        dbController.fetchAll {
            // Do stuff with your fetched objects (Cats)
        }
    }
}
```
You can use variuos operation at DataBase like: 

* Loading
* Saving
* Deleting
* Updating

Note: For full reference visit: [SCDController](https://github.com/wojtowiczm/SwiftyCoreData/blob/master/SwiftyCoreData/SCDController.swift)

## Guide

The trick is to understanding two protocols ```SCDObjectConvertible``` and ```SCDManagedObjectConvertible```. Both of them are needed to use SwiftyCoreData. 

In ```SCDObjectConvertible``` we implement mapping from CoreData Object to Swift Object used inside app. Same story with ```SCDManagedObjectConvertible``` here we provide mapping from Swift Object to CoreData Object.

Let's take a look at example. I will use Cat example because everyone loves those little bastards ;)

We have ```CatManagedObject``` for caching purpose and ```Cat``` used inside our program.

```swift
import CoreData
import SwiftyCoreData

@objc(CatManagedObject)
public class CatManagedObject: NSManagedObject {

    @NSManaged public var name: String?
    @NSManaged public var weight: Double
    @NSManaged public var age: Int16

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CatEntity> {
        return NSFetchRequest<CatManagedObject>(entityName: "CatManagedObject")
    }
}

/* Conform to SCDObjectConvertible */
extension CatManagedObject: SCDObjectConvertible {

    // Associate type of Object we will be converting to
    public typealias Object = Cat

    // Implement mapping algortihm between our ManagedObject and Object
    public func toObject() -> Cat? {
        guard let name = name else { return nil }

        return Cat(name: name, weight: weight, age: Int(age), managedObjectID: objectID)
    }
}
```
Next our Model has to conform to: ```SCDManagedObjectConvertible```

```swift
import CoreData
import SwiftyCoreData

// Note: Our model has to be public since SwiftyCoreData need information about it
public struct Cat {

    let name: String
    let weight: Double
    let age: Int

    // Note: It's good idea to store NSManagedObjectID for later purpose
    var managedObjectID: NSManagedObjectID?
}

/* Conform to SCDManagedObjectConvertible */
extension Cat: SCDManagedObjectConvertible {

    // Here implement algorith for putting our object in data base context
    // We need it for saving etc.
    public func put(in context: NSManagedObjectContext) {
        let catEntity = CatEntity(context: context)
        catEntity.name = self.name
        catEntity.weight = weight
        catEntity.age = Int16(age)
    }
}

```

## Multitreading
SwiftyCoreData is multithread friendly, just define operating queue using 

```SCDOperatingQueue``` (posible values: ```.main```, ```.background```) 

in controller contructor like this:

```SCDController<Obejct, ManagedObject>(with: persistantContainer, operatingQueue: .main)```

## Contributing
Pull requests and comments are welcome.

## License
[MIT](https://choosealicense.com/licenses/mit/)

## References
Mostly inspired by [Better CoreData with generics ](https://swifting.io/blog/2016/11/27/28-better-coredata-with-swift-generics/)
