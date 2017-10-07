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

struct News: CustomStringConvertible {
    
    let type: NewsType
    let sourceID: Int
    let date: Date
    let text: String
    let imagesURL: [String]
    
    var description: String {
        return "sourceID: \(sourceID)" + "\n" +
            "date: \(date)" + "\n" +
        "text: \(text)" + "\n" +
        "imagesUR: \(imagesURL.description)"
    }
}
