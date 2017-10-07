//
//  DeclinedWord.swift
//  VKNews
//
//  Created by Тимур Шафигуллин on 06.10.17.
//  Copyright © 2017 iOS Lab ITIS. All rights reserved.
//

import Foundation

struct DeclinedWord {
    var single: String
    var several: String
    var many: String
}

//Ready to use words
extension DeclinedWord {
    
    static let second = DeclinedWord(single: "секунду", several: "секунды", many: "секунд")
    static let minute = DeclinedWord(single: "минуту", several: "минуты", many: "минут")
    static let hour = DeclinedWord(single: "час", several: "часа", many: "часов")
    static let year = DeclinedWord(single: "год", several: "года", many: "лет")
    
}
