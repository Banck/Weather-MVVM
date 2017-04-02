//
//  City+CoreDataProperties.swift
//  
//
//  Created by Сахабаев Егор on 02.04.17.
//
//

import Foundation
import CoreData


extension City {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<City> {
        return NSFetchRequest<City>(entityName: "City")
    }

    @NSManaged public var cityName: String

}
