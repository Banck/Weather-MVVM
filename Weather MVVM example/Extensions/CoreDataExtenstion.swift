//
//  Created by spens on 10/08/16.
//  Copyright © 2016. All rights reserved.
//

import Foundation
import CoreData
import ObjectiveC
import UIKit

extension NSManagedObject
{
    class var nameOfClass: String
    {
        return NSStringFromClass(self).components(separatedBy: ".").last!
    }
    
    var nameOfClass: String
    {
        return NSStringFromClass(type(of: self)).components(separatedBy: ".").last!
    }
}

extension NSObject
{
    var moc: NSManagedObjectContext
        {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    static var managedObjectContext: NSManagedObjectContext
    {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
}

extension NSManagedObjectContext
{
    /**
     Creates new CoreData object.
     - returns: NSManagedObject
     */
    func createItem<T : NSManagedObject>(_ entity: T.Type) -> T
    {
        let item = NSEntityDescription.insertNewObject(forEntityName: entity.nameOfClass, into: self) as! T
        return item
    }
    
    /**
     Creates new CoreData object.
     You should provide NSDictionary with possible entity properties as keys.
     - returns: NSManagedObject
     */
    func createItem<T : NSManagedObject>(_ entity: T.Type, values: [String:Any]) -> T
    {
        let item = createItem(entity)
        var count: UInt32 = 0
        let properties = class_copyPropertyList(entity, &count)
        for i in 0..<count {
            let property: objc_property_t = properties![Int(i)]!
            let name = NSString(utf8String: property_getName(property))! as String
            for (key, value) in values {
                if name == key {
                    if value is NSNull {
                        continue
                    } else {
                        (item as NSManagedObject).setValue(value, forKey: key)
                    }
                }
            }
        }
        return item
    }
    
    /**
     Updates or creates CoreData object.
     You should provide NSDictionary with possible entity properties as keys.
     - returns: NSManagedObject
     */
    func updateItem<T : NSManagedObject>(_ object: T, entity: T.Type, values: [String:Any]) -> T
    {
        let item = object
        var count: UInt32 = 0
        let properties = class_copyPropertyList(entity, &count)
        for i in 0..<count {
            let property: objc_property_t = properties![Int(i)]!
            let name = NSString(utf8String: property_getName(property))! as String
            for (key, value) in values {
                if name == key {
                    if value is NSNull {
                        continue
                    } else {
                        (item as NSManagedObject).setValue(value, forKey: key)
                    }
                }
            }
        }
        return item
    }
    
    /**
     Get object by dictionary
     You should provide NSDictionary with possible entity properties as keys.
     - returns: NSManagedObject
     */
    func itemWith<T : NSManagedObject>(_ entity: T.Type, values: [String:Any]) -> T?
    {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest()
        let e = NSEntityDescription.entity(forEntityName: entity.nameOfClass, in: self)
        fetchRequest.entity = e
        
        var count: UInt32 = 0
        let properties = class_copyPropertyList(entity, &count)

        var predicateString = ""
        var arr: [Any] = []
        for (key, value) in values {
            for i in 0..<count {
                let property: objc_property_t = properties![Int(i)]!
                let name = NSString(utf8String: property_getName(property))! as String
                if name == key {
                    predicateString = predicateString + "%K == %@ AND "
                    arr.append(key as AnyObject)
                    arr.append(value as AnyObject)
                }
            }
        }
        if predicateString.hasSuffix(" AND ") {
            predicateString = (predicateString as NSString).substring(to: predicateString.characters.count - 5)
        }
        let predicate = NSPredicate(format: predicateString, argumentArray: arr)
        fetchRequest.predicate = predicate
        
        do {
            let fetched = try fetch(fetchRequest)
            return fetched.first as? T
        } catch _ as NSError {
            return nil
        }
    }
    
    /**
     Get object with given values.
     - returns: NSManagedObject
     */
    func itemWith<T : NSManagedObject>(_ entity: T.Type, property: String, value: Any) -> T?
    {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest()
        let e = NSEntityDescription.entity(forEntityName: entity.nameOfClass, in: self)
        fetchRequest.entity = e
        
        let predicate: NSPredicate!
        if value is String {
            predicate = NSPredicate(format: "\(property) == '\(value)'")
        } else {
            predicate = NSPredicate(format: "\(property) == \(value)")
        }
        fetchRequest.predicate = predicate
        fetchRequest.fetchLimit = 1
        
        do {
            let fetched = try fetch(fetchRequest)
            return fetched.first as? T
        } catch _ as NSError {
            return nil
        }
    }
    
    /**
     Check if CoreData object exists with given values.
     - returns: Bool
     */
    func itemExist<T : NSManagedObject>(_ entity: T.Type, property: String, value: Any) -> Bool
    {
        let item = itemWith(entity, property: property, value: value)
        return item != nil
    }
    
    /**
     Check if CoreData object exists with given values.
     You should provide NSDictionary with entity properties as keys.
     - returns: Bool
     */
    func itemExist<T : NSManagedObject>(_ entity: T.Type, values: [String:Any]) -> Bool
    {
        let item = itemWith(entity, values: values)
        return item != nil
    }
    
    /**
     Get all objects by array of predicates and sortDescriptors
     - returns: [NSManagedObject]
     */
    func allItems<T : NSManagedObject>(_ entity: T.Type, predicates: [NSPredicate]?, sort: [NSSortDescriptor]?) -> [T]
    {
        var results: [T] = []
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest()
        let e = NSEntityDescription.entity(forEntityName: entity.nameOfClass, in: self)
        fetchRequest.entity = e
        
        if predicates != nil {
            fetchRequest.predicate = NSCompoundPredicate(orPredicateWithSubpredicates: predicates!)
        }
        if sort != nil {
            fetchRequest.sortDescriptors = sort!
        }
        do {
            let fetched = try fetch(fetchRequest) as! [T]
            results.append(contentsOf: fetched)
            return results
        } catch _ as NSError {
            return results
        }
    }
    
    /**
     Get all objects
     - returns: [NSManagedObject]
     */
    func allItems<T : NSManagedObject>(_ entity: T.Type) -> [T]
    {
        return allItems(entity, predicates: nil, sort: nil)
    }
    
    /**
     Get all objects by array of predicates
     - returns: [NSManagedObject]
     */
    func allItems<T : NSManagedObject>(_ entity: T.Type, predicates: [NSPredicate]) -> [T]
    {
        return allItems(entity, predicates: predicates, sort: nil)
    }
    
    /**
     Get all objects by array of sortDescriptors
     - returns: [NSManagedObject]
     */
    func allItems<T : NSManagedObject>(_ entity: T.Type, sort: [NSSortDescriptor]) -> [T]
    {
        return allItems(entity, predicates: nil, sort: sort)
    }
    
    /**
     Save context
     */
    func saveChanges()
    {
        do {
            try (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext.save()
        } catch let error as NSError {
            NSException.raise(NSExceptionName(rawValue: "Error saving context"), format: "%@", arguments: getVaList([error]))
        }
    }
}

//extension NSManagedObjectContext
//{
//    /**
//     Creates new CoreData object.
//     - returns: NSManagedObject
//     */
//    static func createItem<T : NSManagedObject>() -> T
//    {
//        let item = NSEntityDescription.insertNewObject(forEntityName: T.self.nameOfClass, into: managedObjectContext) as! T
//        return item
//    }
//    
//    /**
//     Creates new CoreData object.
//     You should provide NSDictionary with possible entity properties as keys.
//     - returns: NSManagedObject
//     */
//    static func createItem<T : NSManagedObject>(values: [String:Any]) -> T
//    {
//        let item = T.createItem()
//        var count: UInt32 = 0
//        let properties = class_copyPropertyList(T.self, &count)
//        for i in 0..<count {
//            let property: objc_property_t = properties![Int(i)]!
//            let name = NSString(utf8String: property_getName(property)) as! String
//            for (key, value) in values {
//                if name == key {
//                    if value is NSNull {
//                        continue
//                    } else {
//                        (item as NSManagedObject).setValue(value, forKey: key)
//                    }
//                }
//            }
//        }
//        return item
//    }
//    
//    /**
//     Updates or creates CoreData object.
//     You should provide NSDictionary with possible entity properties as keys.
//     - returns: NSManagedObject
//     */
//    static func updateItem<T : NSManagedObject>(object: T, values: [String:Any]) -> T
//    {
//        let item = object
//        var count: UInt32 = 0
//        let properties = class_copyPropertyList(T.self, &count)
//        for i in 0..<count {
//            let property: objc_property_t = properties![Int(i)]!
//            let name = NSString(utf8String: property_getName(property)) as! String
//            for (key, value) in values {
//                if name == key {
//                    if value is NSNull {
//                        continue
//                    } else {
//                        (item as NSManagedObject).setValue(value, forKey: key)
//                    }
//                }
//            }
//        }
//        return item
//    }
//    
//    /**
//     Get object by dictionary
//     You should provide NSDictionary with possible entity properties as keys.
//     - returns: NSManagedObject
//     */
//    static func itemWith<T : NSManagedObject>(values: [String:Any]) -> T?
//    {
//        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest()
//        let e = NSEntityDescription.entity(forEntityName: T.self.nameOfClass, in: managedObjectContext)
//        fetchRequest.entity = e
//        
//        var count: UInt32 = 0
//        let properties = class_copyPropertyList(T.self, &count)
//        
//        var predicateString = ""
//        var arr: [Any] = []
//        for (key, value) in values {
//            for i in 0..<count {
//                let property: objc_property_t = properties![Int(i)]!
//                let name = NSString(utf8String: property_getName(property)) as! String
//                if name == key {
//                    predicateString = predicateString + "%K == %@ AND "
//                    arr.append(key as AnyObject)
//                    arr.append(value as AnyObject)
//                }
//            }
//        }
//        if predicateString.hasSuffix(" AND ") {
//            predicateString = (predicateString as NSString).substring(to: predicateString.length - 5)
//        }
//        let predicate = NSPredicate(format: predicateString, argumentArray: arr)
//        fetchRequest.predicate = predicate
//        
//        do {
//            let fetched = try fetch(fetchRequest)
//            return fetched.first as? T
//        } catch _ as NSError {
//            return nil
//        }
//    }
//    
//    /**
//     Get object with given values.
//     - returns: NSManagedObject
//     */
//    static func itemWith<T : NSManagedObject>(property: String, value: Any) -> T?
//    {
//        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest()
//        let e = NSEntityDescription.entity(forEntityName: T.self.nameOfClass, in: managedObjectContext)
//        fetchRequest.entity = e
//        
//        let predicate: NSPredicate!
//        if value is String {
//            predicate = NSPredicate(format: "\(property) == '\(value)'")
//        } else {
//            predicate = NSPredicate(format: "\(property) == \(value)")
//        }
//        fetchRequest.predicate = predicate
//        fetchRequest.fetchLimit = 1
//        
//        do {
//            let fetched = try fetch(fetchRequest)
//            return fetched.first as? T
//        } catch _ as NSError {
//            return nil
//        }
//    }
//    
//    /**
//     Check if CoreData object exists with given values.
//     - returns: Bool
//     */
//    static func itemExist(property: String, value: Any) -> Bool
//    {
//        let item = itemWith(property: property, value: value)
//        return item != nil
//    }
//    
//    /**
//     Check if CoreData object exists with given values.
//     You should provide NSDictionary with entity properties as keys.
//     - returns: Bool
//     */
//    static func itemExist(values: [String:Any]) -> Bool
//    {
//        let item = itemWith(values: values)
//        return item != nil
//    }
//    
//    /**
//     Get all objects by array of predicates and sortDescriptors
//     - returns: [NSManagedObject]
//     */
//    static func allItems<T : NSManagedObject>(predicates: [NSPredicate]?, sort: [NSSortDescriptor]?) -> [T]
//    {
//        var results: [T] = []
//        
//        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest()
//        let e = NSEntityDescription.entity(forEntityName: T.self.nameOfClass, in: managedObjectContext)
//        fetchRequest.entity = e
//        
//        if predicates != nil {
//            fetchRequest.predicate = NSCompoundPredicate(orPredicateWithSubpredicates: predicates!)
//        }
//        if sort != nil {
//            fetchRequest.sortDescriptors = sort!
//        }
//        do {
//            let fetched = try fetch(fetchRequest) as! [T]
//            results.append(contentsOf: fetched)
//            return results
//        } catch _ as NSError {
//            return results
//        }
//    }
//    
//    /**
//     Get all objects
//     - returns: [NSManagedObject]
//     */
//    static func allItems<T:NSManagedObject>() -> [T]
//    {
//        return allItems(predicates: nil, sort: nil)
//    }
//    
//    /**
//     Get all objects by array of predicates
//     - returns: [NSManagedObject]
//     */
//    static func allItems<T:NSManagedObject>(predicates: [NSPredicate]) -> [T]
//    {
//        return allItems(predicates: predicates, sort: nil)
//    }
//    
//    /**
//     Get all objects by array of sortDescriptors
//     - returns: [NSManagedObject]
//     */
//    static func allItems<T:NSManagedObject>(sort: [NSSortDescriptor]) -> [T]
//    {
//        return allItems(predicates: nil, sort: sort)
//    }
//}

extension NSManagedObject
{
    /**
     Delete object from DB
     */
    func deleteItem()
    {
        (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext.delete(self)
        do {
            try (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext.save()
        } catch let error as NSError {
            NSException.raise(NSExceptionName(rawValue: "Error saving context"), format: "%@", arguments: getVaList([error]))
        }
    }
}
