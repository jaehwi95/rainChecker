//
//  Double+.swift
//  rainChecker
//
//  Created by Jaehwi Kim on 6/30/24.
//

import Foundation

extension Double {
    func toInt() -> Int? {
        // verify size of double, round to nearest Int
        if self >= Double(Int.min) && self < Double(Int.max) {
            let roundedValue = self.rounded(.toNearestOrAwayFromZero)
            return Int(roundedValue)
        } else {
            return nil
        }
    }
    
    func toPercentage() -> String? {
        let percentage = self
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 0
        if let formattedString = formatter.string(from: NSNumber(value: percentage)) {
            return formattedString
        } else {
            return nil
        }
    }
    
    func toTemperature() -> String {
        let temperature: Measurement<UnitTemperature> = Measurement(value: self, unit: UnitTemperature.celsius)
        let formatter = MeasurementFormatter()
        formatter.unitStyle = .medium
        formatter.numberFormatter.maximumFractionDigits = 0
        formatter.numberFormatter.roundingMode = .halfUp
        formatter.unitOptions = .providedUnit
        return formatter.string(from: temperature.converted(to: .celsius))
    }
}
