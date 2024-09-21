//
//  HourlyCardView.swift
//  rainChecker
//
//  Created by Jaehwi Kim on 9/21/24.
//

import SwiftUI

struct HourlyCardView: View {
    private let time: String
    private let iconName: String
    private let feelsLikeTemperature: Double
    private let actualTemperature: Double
    private let humidity: Double
    private let precipitaionChance: Double
    @State private var isFlip = false
    
    public init(
        time: String,
        iconName: String,
        feelsLikeTemperature: Double,
        actualTemperature: Double,
        humidity: Double,
        precipitaionChance: Double
    ) {
        self.time = time
        self.iconName = iconName
        self.feelsLikeTemperature = feelsLikeTemperature
        self.actualTemperature = actualTemperature
        self.humidity = humidity
        self.precipitaionChance = precipitaionChance
    }
    
    var body: some View {
        FlipCardView(
            frontView: FrontHourlyCardView(
                time: time,
                iconName: iconName,
                precipitationChance: precipitaionChance
            ),
            backView: BackHourlyCardView(
                time: time,
                actualTemperature: feelsLikeTemperature,
                feelsLikeTemperature: feelsLikeTemperature,
                humidity: humidity
            ),
            isFlip: $isFlip
        )
    }
}

#Preview {
    HourlyCardView(
        time: "16:00",
        iconName: "rain",
        feelsLikeTemperature: 36,
        actualTemperature: 31,
        humidity: 0.73,
        precipitaionChance: 0.13
    )
}
