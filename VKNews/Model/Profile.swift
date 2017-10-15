//
//  Profiles.swift
//  VKNews
//
//  Created by Тимур Шафигуллин on 01.10.17.
//  Copyright © 2017 iOS Lab ITIS. All rights reserved.
//

import UIKit

struct Profile: Source, CustomStringConvertible {
    
    var name: String
    let surname: String
    var photoURL: URL
    
    var description: String {
        return "name: \(name)" + "\n" +
                "surname: \(surname)" + "\n" +
                "photoURL: \(photoURL)"
    }
    
}
