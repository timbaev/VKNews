//
//  ImageRounder.swift
//  VKNews
//
//  Created by Тимур Шафигуллин on 07.10.17.
//  Copyright © 2017 iOS Lab ITIS. All rights reserved.
//

import UIKit

extension UIImageView {
    
    func roundCorners() {
        self.layer.cornerRadius = self.frame.size.width / 2
        self.clipsToBounds = true
    }
    
}
