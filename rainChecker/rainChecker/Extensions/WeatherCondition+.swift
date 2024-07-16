//
//  WeatherCondition+.swift
//  rainChecker
//
//  Created by Jaehwi Kim on 2024/07/15.
//

import Foundation
import WeatherKit

extension WeatherCondition {
    var jsonName: String {
        switch self {
        case .blowingDust:
            return "dust"
        case .foggy, .haze, .smoky:
            return "fog"
        case .hail, .freezingRain, .freezingDrizzle:
            return "hail"
        case .hurricane, .strongStorms, .tropicalStorm:
            return "hurricane"
        case .thunderstorms, .isolatedThunderstorms, .scatteredThunderstorms:
            return "thunderstorms-day"
        case .windy, .breezy:
            return "wind"
        case .clear, .mostlyClear, .hot:
            return "clear-day"
        case .cloudy, .mostlyCloudy:
            return "cloudy"
        case .rain, .heavyRain, .sunShowers:
            return "rain"
        case .drizzle:
            return "drizzle"
        case .snow, .blizzard, .blowingSnow, .flurries, .frigid, .heavySnow, .sleet, .sunFlurries, .wintryMix:
            return "snow"
        case .partlyCloudy:
            return "partly-cloudy-day"
        @unknown default:
            return "clear-day"
        }
    }
}

