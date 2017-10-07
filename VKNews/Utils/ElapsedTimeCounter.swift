//
//  ElapsedTimeCounter.swift
//  VKNews
//
//  Created by Тимур Шафигуллин on 06.10.17.
//  Copyright © 2017 iOS Lab ITIS. All rights reserved.
//

import Foundation

extension Date {
    
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    
    func offset(from date: Date) -> String {
        let ago = "назад"
        let dateFormat = "d MMM"
        let timeString = "\(hours(from: date)):\(minutes(from: date))"
        
        let daysAgo = days(from: date)
        if daysAgo >= 2 {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = dateFormat
            dateFormatter.locale = Locale(identifier: "ru")
            let dateString = dateFormatter.string(from: date)
            return "\(dateString) в \(timeString)"
        }
        
        if daysAgo < 2, daysAgo >= 1 {
            return "Вчера в \(timeString)"
        }
        
        let hoursAgo = hours(from: date)
        if hoursAgo > 0 {
            return "\(hoursAgo) \(WordEndPicker.getCorrectEnding(with: hoursAgo, and: DeclinedWord.hour)) \(ago)"
        }
        
        let minutesAgo = minutes(from: date)
        if minutesAgo > 0 {
            return "\(minutesAgo) \(WordEndPicker.getCorrectEnding(with: minutesAgo, and: DeclinedWord.minute)) \(ago)"
        }
        
        let secondsAgo = seconds(from: date)
        if secondsAgo > 0 {
            return "\(secondsAgo) \(WordEndPicker.getCorrectEnding(with: secondsAgo, and: DeclinedWord.second)) \(ago)"
        }
        
        return ""
    }
    
}
