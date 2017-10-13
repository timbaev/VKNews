//
//  NewsManaged+CoreDataProperties.swift
//  VKNews
//
//  Created by Тимур Шафигуллин on 13.10.17.
//  Copyright © 2017 iOS Lab ITIS. All rights reserved.
//
//

import Foundation
import CoreData


extension NewsManaged {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NewsManaged> {
        return NSFetchRequest<NewsManaged>(entityName: "NewsManaged")
    }

    @NSManaged public var date: NSDate?
    @NSManaged public var text: String?
    @NSManaged public var type: Bool
    @NSManaged public var imageLinks: [String]
    @NSManaged public var sourceID: Int32

}
