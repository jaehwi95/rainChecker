//
//  Date+.swift
//  rainChecker
//
//  Created by Jaehwi Kim on 6/30/24.
//

import Foundation

extension Date {
    var toLocalTimeString: String {
        let formatter: DateFormatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.locale = Locale.current
        return formatter.string(from: self)
    }
}
