//
//  WeatherManager.swift
//  rainChecker
//
//  Created by Jaehwi Kim on 6/12/24.
//

import Foundation
import WeatherKit
import Combine
import CoreLocation

final class WeatherManager {
    public static let shared = WeatherManager()
    
    private let weatherService = WeatherService()
    
    private init() {}
    
    func getCurrentWeather(location: CLLocation) async -> Result<CurrentWeatherModel, Error> {
        do {
            let currentWeather = try await weatherService.weather(for: location).currentWeather
            let currentWeatherModel = CurrentWeatherModel(
                feelsLikeTemperature: currentWeather.apparentTemperature.value,
                actualTemperature: currentWeather.temperature.value,
                humidity: currentWeather.humidity,
                weather: currentWeather.condition,
                symbolName: currentWeather.symbolName
            )
            return .success(currentWeatherModel)
        } catch {
            return .failure(error)
        }
    }
    
    func getHourlyPrecipitation(location: CLLocation) async -> Result<[Double], Error> {
        do {
            let hourlyPrecipitation = try await weatherService
                .weather(for: location, including: .daily)
                .map(\.precipitationChance)
            return .success(hourlyPrecipitation)
        } catch {
            return .failure(error)
        }
    }
    
    func getTodayForecast(location: CLLocation) async -> Result<Weather, Error> {
        do {
            let weather = try await weatherService.weather(for: location)
//            if let dailyForecast = weather.dailyForecast {
//                if let today = dailyForecast.forecast.first {
//                    
//                }
//            }
            return .success(weather)
        } catch {
            return .failure(error)
        }
    }
}
