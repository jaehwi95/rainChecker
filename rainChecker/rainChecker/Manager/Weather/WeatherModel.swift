//
//  WeatherModel.swift
//  rainChecker
//
//  Created by Jaehwi Kim on 6/14/24.
//

import Foundation
import WeatherKit

struct CurrentWeatherModel {
    let feelsLikeTemperature: Double
    let actualTemperature: Double
    let humidity: Double
    let weather: WeatherCondition
    let symbolName: String
    let isRaining: Bool
    
    init() {
        self.feelsLikeTemperature = 0.0
        self.actualTemperature = 0.0
        self.humidity = 0.0
        self.weather = .clear
        self.symbolName = ""
        self.isRaining = false
    }
    
    init(
        feelsLikeTemperature: Double,
        actualTemperature: Double,
        humidity: Double,
        weather: WeatherCondition,
        symbolName: String
    ) {
        self.feelsLikeTemperature = feelsLikeTemperature
        self.actualTemperature = actualTemperature
        self.humidity = humidity
        self.weather = weather
        self.symbolName = symbolName
        switch weather {
        // All raining weather conditions
        case .drizzle, .heavyRain, .isolatedThunderstorms, .rain, .sunShowers, .scatteredThunderstorms, .strongStorms, .thunderstorms:
            self.isRaining = true
        default:
            self.isRaining = false
        }
    }
}
