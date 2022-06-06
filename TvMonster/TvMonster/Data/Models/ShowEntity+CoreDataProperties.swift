//
//  ShowEntity+CoreDataProperties.swift
//  TvMonster
//
//  Created by Obed Garcia on 5/6/22.
//
//

import Foundation
import CoreData


extension ShowEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ShowEntity> {
        return NSFetchRequest<ShowEntity>(entityName: "ShowEntity")
    }

    @NSManaged public var date: String?
    @NSManaged public var days: String?
    @NSManaged public var genres: String?
    @NSManaged public var id: String?
    @NSManaged public var mediumimage: String?
    @NSManaged public var name: String?
    @NSManaged public var originalimage: String?
    @NSManaged public var rating: String?
    @NSManaged public var showid: Int64
    @NSManaged public var summary: String?
    @NSManaged public var time: String?

}

extension ShowEntity : Identifiable {

}
