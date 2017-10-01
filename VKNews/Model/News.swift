//
//  Post.swift
//  VKNews
//
//  Created by Тимур Шафигуллин on 01.10.17.
//  Copyright © 2017 iOS Lab ITIS. All rights reserved.
//

import UIKit

enum NewsType {
    case post
    case copy
}

struct News {
    
    let type: NewsType
    let sourceID: Int
    let date: Date
    let text: String
    let photos: [UIImage]
    
}
