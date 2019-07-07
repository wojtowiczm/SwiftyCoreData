# SwiftyCoreData
SwiftyCoreData is a lightweight library written in Swift. Main purpose is to make using CoreData easier. Library uses power of Swift Generics and Protocols.
> The 'SwiftyCoreData' name was originally used in
> pod made by [Cyrwil Garcia](https://github.com/cyrilivargarcia)

## Advantages
* Thread Safe
* Declarative syntax
* Immutable
* No shared state
* No boilerplate code

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
            // Do stuff with your fetched objects
        }
    }
}
```
You can use various operation at DataBase like:

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

    // Implement mapping algorithm between our ManagedObject and Object
    public func toObject() -> Object? {
        return Object(...)
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

    // Here implement algorithm for putting our object in data base context
    // We need it for saving etc.
    public func put(in context: NSManagedObjectContext) {
        let catEntity = CatEntity(context: context)
        catEntity.name = self.name
        catEntity.weight = weight
        catEntity.age = Int16(age)
    }
}

```

## Performance
Average times of particular operations:
* Read (for 100 000 objects)
```
SwiftyCoreData average read time: 28.786418461563564 ms
CoreData average read time: 43.380704256567626 ms
```
* Write (for 1000 objects)
```
SwiftyCoreData average write time: 19.355168437013532 ms
CoreData average write time: 24.809918781318288 ms
```
For more details visit [Benchmark](https://github.com/wojtowiczm/SwiftyCoreData/tree/develop/Benchmark)

## Multitreading
SwiftyCoreData is multithread friendly, just define operating queue using

```SCDOperatingQueue``` (posible values: ```.main```, ```.background```)

in controller constructor like this:

```SCDController<Obejct, ManagedObject>(with: persistanceContainer, operatingQueue: .main)```

## Contributing
Pull requests and comments are welcome.

## License
[MIT](https://choosealicense.com/licenses/mit/)

## References
Mostly inspired by [Better CoreData with generics ](https://swifting.io/blog/2016/11/27/28-better-coredata-with-swift-generics/)
