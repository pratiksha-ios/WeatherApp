//
//  Date+Extension.swift
//  WeatherApp
//
//  Created by Admin on 2020/06/07.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation

extension NSDate {
    
    ///Returns the time of a date formatted as "HH:mm" (e.g. 18:30)
    func formattedTime(formatter: DateFormatter)-> String {
        formatter.setLocalizedDateFormatFromTemplate("HH:mm")
        return formatter.string(from: self as Date)
    }
    
    ///Returns a string in "d M" format, e.g. 19/9 for June 19.
    func formattedDay(formatter: DateFormatter)-> String {
        //the reason formatter is injected is because creating an
        //NSDateFormatter instance is pretty expensive
        formatter.setLocalizedDateFormatFromTemplate("d M")
        return formatter.string(from: self as Date)
    }
    
    ///Returns the week day of the NSDate, e.g. Sunday.
    func dayOfWeek(formatter: DateFormatter)-> String {
        //the reason formatter is injected is because creating an
        //NSDateFormatter instance is pretty expensive
        formatter.setLocalizedDateFormatFromTemplate("EEEE")
        return formatter.string(from: self as Date)
    }
    func dayNumberOfWeek() -> Int? {
        return Calendar.current.dateComponents([.weekday], from: self as Date).weekday
    }
    
    func dayOfWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self as Date).capitalized
    }
    
    
    func dateAtBeginningOfDay() -> Date? {
        var calendar = Calendar.current
        // Or whatever you need
        // if server returns date in UTC better to use UTC too
        let timeZone = NSTimeZone.system
        calendar.timeZone = timeZone
        
        // Selectively convert the date components (year, month, day) of the input date
        var dateComps = calendar.dateComponents([.year, .month, .day], from: self as Date)
        // Set the time components manually
        dateComps.hour = 0
        dateComps.minute = 0
        dateComps.second = 0
        
        // Convert back
        let beginningOfDay = calendar.date(from: dateComps)
        return beginningOfDay
    }
    
}


//MARK: - Comparable

extension NSDate: Comparable {}

func ==(lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs.isEqual(to: rhs as Date)
}

public func <(lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs.earlierDate(rhs as Date) == lhs as Date
}
