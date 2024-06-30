//
//  Double+.swift
//  rainChecker
//
//  Created by Jaehwi Kim on 6/30/24.
//

extension Double {
    func toInt() -> Int? {
        // verify size of double, round to nearest Int
        if self >= Double(Int.min) && self < Double(Int.max) {
            let roundedValue = self.rounded(.toNearestOrAwayFromZero)
            return Int(self)
        } else {
            return nil
        }
    }
}
