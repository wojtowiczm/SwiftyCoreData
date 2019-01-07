# SwiftyCoreData

SwiftyCoreData is a lightweight libliary written in Swift. General purpose is to make using CoreData easier without unnecessary template code

## Installation

SwiftyCoreData is currently avaliable on CocoaPods for beta testers. Just type for now:

```bash
pod 'SwiftyCoreData', :git => 'https://github.com/wojtowiczm/SwiftyCoreData.git', :branch => 'develop'

```
in your podfile

## Usage
After implementing all steps showed below our logic Code will look like

## Step by step
First of all create your .xcdatamodeld with proper ManagedObjects and generate ManagedObject subclass in your code. You can use default code generator provided by xCode. (Editor > Create NSManagedObjectSubclass...)*

```swift
import CoreData
import SwiftyCoreData

@objc(CatEntity)
public class CatEntity: NSManagedObject {

    @NSManaged public var name: String?
    @NSManaged public var weight: Double
    @NSManaged public var age: Int16

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CatEntity> {
        return NSFetchRequest<CatEntity>(entityName: "CatEntity")
    }

}
```
Next our ManagedObject should conform to: ```SCDObjectConvertible```.

```swift

extension CatEntity: SCDObjectConvertible {

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

public struct Cat {

    let name: String
    let weight: Double
    let age: Int

    // It's good idea to store NSManagedObjectID for later purpose
    var managedObjectID: NSManagedObjectID?
}

extension Cat: SCDManagedObjectConvertible {

    // Here implement algorith for putting our object in data base context
    public func put(in context: NSManagedObjectContext) {
        let catEntity = CatEntity(context: context)
        catEntity.name = self.name
        catEntity.weight = weight
        catEntity.age = Int16(age)
    }
}

```

Finally create Service that conform to ```SCDPersistanceService```. We need here to provide proper ```NSPersistentContainer```

```swift
import CoreData
import SwiftyCoreData

class PersistanceService: SCDPersistanceService {

    private init() {}

    static var shared: PersistanceService {
        return PersistanceService()
    }

    var persistanceContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "SwiftyCoreDataExample")
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()

}
```

## Contributing
Pull requests and comments are welcome.

## License
[MIT](https://choosealicense.com/licenses/mit/)
