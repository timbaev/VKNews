//
//  Group.swift
//  VKNews
//
//  Created by Тимур Шафигуллин on 01.10.17.
//  Copyright © 2017 iOS Lab ITIS. All rights reserved.
//

import UIKit

struct Group: Source, CustomStringConvertible {
    
    var name: String
    var photoURL: String
    
    var description: String {
        return "name: \(name)" + "\n" +
        "photoURL: \(photoURL)"
    }
    
}
