//
//  Category+CoreDataProperties.swift
//  
//
//  Created by Arttu Jokinen on 22/11/2019.
//
//

import Foundation
import CoreData


extension Category {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Category> {
        return NSFetchRequest<Category>(entityName: "Category")
    }

    @NSManaged public var categoryName: NSObject?
    @NSManaged public var categorySummary: NSObject?
    @NSManaged public var availableStudies: Studies?
    @NSManaged public var availableWork: Work?

}
