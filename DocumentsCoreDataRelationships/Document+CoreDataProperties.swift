//
//  Document+CoreDataProperties.swift
//  DocumentsCoreDataRelationships
//
//  Created by Brady Webb on 9/27/19.
//  Copyright © 2019 Brady Webb. All rights reserved.
//
//

import Foundation
import CoreData


extension Document {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Document> {
        return NSFetchRequest<Document>(entityName: "Document")
    }

    @NSManaged public var content: String?
    @NSManaged public var name: String?
    @NSManaged public var rawModifiedDate: Date?
    @NSManaged public var size: Int64
    @NSManaged public var category: Category?

}
