//
//  Date+.swift
//  rainChecker
//
//  Created by Jaehwi Kim on 6/30/24.
//

import Foundation

extension Date {
    func utcTolocalDate() -> Date {
        let timezone = TimeZone.current
        let seconds = TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }
    
    func localToUTCDate() -> Date {
        let timeZone = TimeZone.current
        let seconds = TimeInterval(timeZone.secondsFromGMT(for: self))
        return self.addingTimeInterval(-seconds)
    }
    
    func extractComponent(_ component: DateExtractComponent) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = component.rawValue
        return formatter.string(from: self)
    }
    
    func isAfterCurrentHour() -> Bool {
        let calendar = Calendar.current
        let currentDateComponents = calendar.dateComponents([.year, .month, .day, .hour], from: Date())
        let currentDate = calendar.date(from: currentDateComponents)!
        
        return self >= currentDate
    }
    
    static var startOfDay: Date {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: Date.now)
        return startOfDay
    }
    
    static var tomorrowStartOfDay: Date {
        let calendar = Calendar.current
        if let tomorrowDay = calendar.date(byAdding: .day, value: 1, to: Date.now) {
            let tomorrowStartOfDay = calendar.startOfDay(for: tomorrowDay)
            return tomorrowStartOfDay
        } else {
            return Date.now
        }
    }
    
    static var nextWeekEndOfDay: Date {
        let calendar = Calendar.current
        if let nextWeekDay = calendar.date(byAdding: .day, value: 8, to: Date.now) {
            let nextWeekEndOfDay = calendar.startOfDay(for: nextWeekDay)
            return nextWeekEndOfDay
        } else {
            return Date.now
        }
    }
}

enum DateExtractComponent: String {
    case hourMinute = "HH:mm"
}
