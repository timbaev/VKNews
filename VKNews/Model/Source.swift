//
//  Source.swift
//  VKNews
//
//  Created by Тимур Шафигуллин on 05.10.17.
//  Copyright © 2017 iOS Lab ITIS. All rights reserved.
//

import UIKit

protocol Source {
    var name: String { get set }
    var photoURL: URL { get set }
}
