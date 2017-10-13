//
//  SourceManaged+CoreDataClass.swift
//  VKNews
//
//  Created by Тимур Шафигуллин on 13.10.17.
//  Copyright © 2017 iOS Lab ITIS. All rights reserved.
//
//

import Foundation
import CoreData


public class SourceManaged: NSManagedObject {
    convenience init() {
        self.init(entity: CoreDataManager.instance.entity(for: "SourceManaged"), insertInto: CoreDataManager.instance.managedObjectContext)
    }
}
