//
//  WordEndPicker.swift
//  VKNews
//
//  Created by Тимур Шафигуллин on 06.10.17.
//  Copyright © 2017 iOS Lab ITIS. All rights reserved.
//

import Foundation

class WordEndPicker {
    
    static func getCorrectEnding(with count: Int, and word: DeclinedWord) -> String {
        var val = count % 100
        
        if (val > 10 && val < 20) {
            return word.many
        } else {
            val = count % 10
            if (val == 1) {
                return word.single
            }
            else if (val > 1 && val < 5) {
                return word.several
            }
            else {
                return word.many
            }
        }
    }
    
}
