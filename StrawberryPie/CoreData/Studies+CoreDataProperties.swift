//
//  Studies+CoreDataProperties.swift
//  
//
//  Created by iosdev on 22/11/2019.
//
//

import Foundation
import CoreData


extension Studies {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Studies> {
        return NSFetchRequest<Studies>(entityName: "Studies")
    }

    @NSManaged public var studyName: NSObject?
    @NSManaged public var studySummary: NSObject?

}
