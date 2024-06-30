//
//  WeatherModel.swift
//  rainChecker
//
//  Created by Jaehwi Kim on 6/14/24.
//

import Foundation
import WeatherKit

struct CurrentWeatherModel {
    let feelsLikeTemperature: Int
    let actualTemperature: Int
    let humidity: Double
    let weather: WeatherCondition
    let symbolName: String
    let isRaining: Bool
    
    init() {
        self.feelsLikeTemperature = 0
        self.actualTemperature = 0
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
        self.feelsLikeTemperature = feelsLikeTemperature.toInt() ?? 0
        self.actualTemperature = actualTemperature.toInt() ?? 0
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

struct TodayForecastModel {
    let highTemperature: Double
    let lowTemperature: Double
    let highTemperatureTime: Date
    let lowTemperatureTime: Date
    let isRain: Bool
    let precipitationChance: Double
    let startTime: Date
    let symbolName: String
    
    init() {
        self.highTemperature = 0.0
        self.lowTemperature = 0.0
        self.highTemperatureTime = .now
        self.lowTemperatureTime = .now
        self.isRain = false
        self.precipitationChance = 0.0
        self.startTime = .now
        self.symbolName = ""
    }
}
