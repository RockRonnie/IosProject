//
//  Work+CoreDataProperties.swift
//  
//
//  Created by iosdev on 22/11/2019.
//
//

import Foundation
import CoreData


extension Work {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Work> {
        return NSFetchRequest<Work>(entityName: "Work")
    }

    @NSManaged public var workPositionName: NSObject?
    @NSManaged public var workSummary: NSObject?

}
