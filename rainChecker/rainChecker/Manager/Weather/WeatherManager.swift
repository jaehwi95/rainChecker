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
                symbolName: currentWeather.symbolName,
                date: currentWeather.date
            )
            return .success(currentWeatherModel)
        } catch {
            return .failure(error)
        }
    }
    
    func getTodayWeatherForecast(location: CLLocation) async -> Result<[HourlyForecastModel], Error> {
        do {
            let hourlyWeatherForecast = try await weatherService
                .weather(for: location, including: .hourly(startDate: Date.startOfDay, endDate: Date.tomorrowStartOfDay))
            let hourlyWeatherModels: [HourlyForecastModel] = hourlyWeatherForecast.map { weatherForecast in
                HourlyForecastModel(
                    feelsLikeTemperature: weatherForecast.apparentTemperature.value,
                    actualTemperature: weatherForecast.temperature.value,
                    humidity: weatherForecast.humidity,
                    date: weatherForecast.date,
                    precipitationChance: weatherForecast.precipitationChance,
                    precipitation: weatherForecast.precipitation,
                    symbolName: weatherForecast.symbolName,
                    weather: weatherForecast.condition,
                    precipitationAmount: weatherForecast.precipitationAmount
                )
            }
            return .success(hourlyWeatherModels)
        } catch {
            return .failure(error)
        }
    }
    
    func getWeekWeatherForecast(location: CLLocation) async -> Result<[WeeklyForecastModel], Error> {
        do {
            let dailyWeatherForecast = try await weatherService
                .weather(for: location, including: .daily(startDate: Date.tomorrowStartOfDay, endDate: Date.nextWeekEndOfDay))
            let dailyWeatherModels: [WeeklyForecastModel] = dailyWeatherForecast.map { weatherForecast in
                WeeklyForecastModel(
                    highTemperature: weatherForecast.highTemperature.value,
                    lowTemperature: weatherForecast.lowTemperature.value,
                    precipitation: weatherForecast.precipitation,
                    precipitationChance: weatherForecast.precipitationChance,
                    date: weatherForecast.date,
                    weather: weatherForecast.condition,
                    symbolName: weatherForecast.symbolName
                )
            }
            return .success(dailyWeatherModels)
        } catch {
            return .failure(error)
        }
    }
    
    func getWeatherAttribution() async -> Result<WeatherAttributionModel, Error> {
        do {
            let attribution = try await weatherService.attribution
            let weatherAttributionModel: WeatherAttributionModel
            if #available(iOS 16.4, *) {
                weatherAttributionModel = WeatherAttributionModel(
                    legalPageURL: attribution.legalPageURL,
                    lightLogoTextURL: attribution.combinedMarkLightURL,
                    darkLogoTextURL: attribution.combinedMarkDarkURL,
                    legalAttributionText: attribution.legalAttributionText
                )
            } else {
                weatherAttributionModel = WeatherAttributionModel(
                    legalPageURL: attribution.legalPageURL,
                    lightLogoTextURL: attribution.combinedMarkLightURL,
                    darkLogoTextURL: attribution.combinedMarkDarkURL,
                    legalAttributionText: ""
                )
            }
            return .success(weatherAttributionModel)
        } catch {
            return .failure(error)
        }
    }
}
