//
//  MainWeatherViewModel.swift
//  rainChecker
//
//  Created by Jaehwi Kim on 6/12/24.
//

import SwiftUI
import Combine
import CoreLocation

@MainActor
class MainWeatherViewModel: ObservableObject {
    private let locationManager = LocationManager.shared
    var currentLocation: CLLocation { locationManager.currentLocation ?? .seoul }
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    private var task: Task<Void, Never>? = nil
    @Published var currentLocationString: String = ""
    
    @Published var currentWeatherModel: CurrentWeatherModel = .init()
    @Published var hourlyForecastModels: [HourlyForecastModel] = []
    @Published var weeklyForecastModels: [WeeklyForecastModel] = []
    @Published var todayRainPercentage: String = ""
    
    init() {
        task = Task {
            await observeAuthorizationStatus()
        }
    }
    
    deinit {
        task?.cancel()
    }
}

// Location Logics
extension MainWeatherViewModel {
    private func observeAuthorizationStatus() async {
        do {
            for try await newStatus in LocationManager.shared.authorizationStatusStream {
                self.authorizationStatus = newStatus
            }
        } catch {
            if let locationError = error as? LocationError {
                // TODO: handle error
                print("LocationError: \(locationError)")
            }
        }
    }
    
    private func reverseGeocode(location: CLLocation) async -> Result<(city: String, country: String), GeocodeError> {
        do {
            let placeMarks: [CLPlacemark] = try await CLGeocoder().reverseGeocodeLocation(location)
            if let placemark = placeMarks.first {
                guard let city = placemark.locality else {
                    return .failure(.invalidCity)
                }
                guard let country = placemark.country else {
                    return .failure(.invalidCountry)
                }
                return .success((city, country))
            } else {
                return .failure(.invalidPlacemark)
            }
        } catch {
            return .failure(.reverseGeocodeFailure)
        }
    }
    
    func getCurrentLocation() async {
        let result = await reverseGeocode(location: currentLocation)
        switch result {
        case .success(let data):
            currentLocationString = "\(data.city), \(data.country)"
        case .failure(let geocodeError):
            // TODO: handle error
            print("GeocodeError: \(geocodeError)")
        }
    }
}

// Weather Logics
extension MainWeatherViewModel {
    func getCurrentWeather() async {
        let result = await WeatherManager.shared.getCurrentWeather(location: currentLocation)
        switch result {
        case .success(let data):
            currentWeatherModel = data
        case .failure(let failure):
            print("Error: \(failure)")
        }
    }
    
    func getTodayWeatherForecast() async {
        let result = await WeatherManager.shared.getTodayWeatherForecast(location: currentLocation)
        switch result {
        case .success(let data):
//            let filteredModels = data.filter{ hourlyForecastModel in
//                hourlyForecastModel.date.isAfterCurrentHour()
//            }
            hourlyForecastModels = data
        case .failure(let failure):
            print("Error: \(failure)")
        }
    }
    
    func getWeekWeatherForecast() async {
        let result = await WeatherManager.shared.getWeekWeatherForecast(location: currentLocation)
        switch result {
        case .success(let data):
            weeklyForecastModels = data
            todayRainPercentage = (weeklyForecastModels.first?.precipitationChance ?? 0.0).toPercentage() ?? ""
        case .failure(let failure):
            print("Error: \(failure)")
        }
    }
}
