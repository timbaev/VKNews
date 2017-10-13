//
//  SourceManaged+CoreDataProperties.swift
//  VKNews
//
//  Created by Тимур Шафигуллин on 13.10.17.
//  Copyright © 2017 iOS Lab ITIS. All rights reserved.
//
//

import Foundation
import CoreData


extension SourceManaged {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SourceManaged> {
        return NSFetchRequest<SourceManaged>(entityName: "SourceManaged")
    }

    @NSManaged public var name: String
    @NSManaged public var sourceID: Int32
    @NSManaged public var avatar: String
    @NSManaged public var avatarImageData: Data?

}
