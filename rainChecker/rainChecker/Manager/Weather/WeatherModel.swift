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
    let date: Date
    let isRaining: Bool
    
    init() {
        self.feelsLikeTemperature = 0.0
        self.actualTemperature = 0.0
        self.humidity = 0.0
        self.weather = .clear
        self.symbolName = ""
        self.date = .now
        self.isRaining = false
    }
    
    init(
        feelsLikeTemperature: Double,
        actualTemperature: Double,
        humidity: Double,
        weather: WeatherCondition,
        symbolName: String,
        date: Date
    ) {
        self.feelsLikeTemperature = feelsLikeTemperature
        self.actualTemperature = actualTemperature
        self.humidity = humidity
        self.weather = weather
        self.symbolName = symbolName
        self.date = date
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

struct HourlyForecastModel: Hashable, Identifiable {
    let id: UUID = UUID()
    let feelsLikeTemperature: Double
    let actualTemperature: Double
    let humidity: Double
    let date: Date
    let precipitationChance: Double
    let precipitation: Precipitation
    let symbolName: String
    let weather: WeatherCondition
    let precipitationAmount: Measurement<UnitLength>
    
    init(
        feelsLikeTemperature: Double,
        actualTemperature: Double,
        humidity: Double,
        date: Date,
        precipitationChance: Double,
        precipitation: Precipitation,
        symbolName: String,
        weather: WeatherCondition,
        precipitationAmount: Measurement<UnitLength>
    ) {
        self.feelsLikeTemperature = feelsLikeTemperature
        self.actualTemperature = actualTemperature
        self.humidity = humidity
        self.date = date
        self.precipitationChance = precipitationChance
        self.precipitation = precipitation
        self.symbolName = symbolName
        self.weather = weather
        self.precipitationAmount = precipitationAmount
    }
}

struct WeeklyForecastModel: Hashable {
    let highTemperature: Double
    let lowTemperature: Double
    let precipitation: Precipitation
    let precipitationChance: Double
    let date: Date
    let weather: WeatherCondition
    let symbolName: String
    
    init(
        highTemperature: Double,
        lowTemperature: Double,
        precipitation: Precipitation,
        precipitationChance: Double,
        date: Date,
        weather: WeatherCondition,
        symbolName: String
    ) {
        self.highTemperature = highTemperature
        self.lowTemperature = lowTemperature
        self.precipitation = precipitation
        self.precipitationChance = precipitationChance
        self.date = date
        self.weather = weather
        self.symbolName = symbolName
    }
}

struct WeatherAttributionModel {
    let legalPageURL: URL
    let lightLogoTextURL: URL
    let darkLogoTextURL: URL
    let legalAttributionText: String
    
    init() {
        self.legalPageURL = URL(string: "https://developer.apple.com/weatherkit/data-source-attribution/")!
        self.lightLogoTextURL = URL(string: "https://weatherkit.apple.com/assets/branding/en/Apple_Weather_blk_en_3X_090122.png")!
        self.darkLogoTextURL = URL(string: "https://weatherkit.apple.com/assets/branding/en/Apple_Weather_wht_en_3X_090122.png")!
        self.legalAttributionText = ""
    }
    
    init(
        legalPageURL: URL,
        lightLogoTextURL: URL,
        darkLogoTextURL: URL,
        legalAttributionText: String
    ) {
        self.legalPageURL = legalPageURL
        self.lightLogoTextURL = lightLogoTextURL
        self.darkLogoTextURL = darkLogoTextURL
        self.legalAttributionText = legalAttributionText
    }
}
