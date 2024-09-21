//
//  BackHourlyCardView.swift
//  rainChecker
//
//  Created by Jaehwi Kim on 9/21/24.
//

import SwiftUI

struct BackHourlyCardView: View {
    private let time: String
    private let actualTemperature: Double
    private let feelsLikeTemperature: Double
    private let humidity: Double
    
    public init(
        time: String,
        actualTemperature: Double,
        feelsLikeTemperature: Double,
        humidity: Double
    ) {
        self.time = time
        self.actualTemperature = actualTemperature
        self.feelsLikeTemperature = feelsLikeTemperature
        self.humidity = humidity
    }
    
    var body: some View {
        VStack(spacing: 4) {
            Text("\(time)")
            iconRow(
                iconName: "thermometer.medium",
                text: actualTemperature.toTemperature()
            )
            iconRow(
                iconName: thermometerIconName(),
                text: feelsLikeTemperature.toTemperature()
            )
            iconRow(
                iconName: "humidity",
                text: humidity.toPercentage()
            )
        }
    }
    
    private func iconRow(iconName: String, text: String) -> some View {
        return HStack(spacing: 10) {
            Image(systemName: iconName)
            Text(text)
                .font(.system(size: 14))
        }
    }
    
    private func thermometerIconName() -> String {
        if #available(iOS 17.0, *) {
            return "thermometer.variable.and.figure"
        } else {
            return "medical.thermometer"
        }
    }
}

#Preview {
    BackHourlyCardView(
        time: "16:00",
        actualTemperature: 31,
        feelsLikeTemperature: 36,
        humidity: 0.73
    )
}
