//
//  NewsManaged+CoreDataClass.swift
//  VKNews
//
//  Created by Тимур Шафигуллин on 13.10.17.
//  Copyright © 2017 iOS Lab ITIS. All rights reserved.
//
//

import Foundation
import CoreData


public class NewsManaged: NSManagedObject {
    convenience init() {
        self.init(entity: CoreDataManager.instance.entity(for: CoreDataStore.newsManagedName), insertInto: CoreDataManager.instance.managedObjectContext)
    }
}
