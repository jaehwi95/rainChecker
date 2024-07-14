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
    @Published var isLoading: Bool = false
    
    private let locationManager = LocationManager.shared
    var currentLocation: CLLocation { locationManager.currentLocation ?? .seoul }
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    private var task: Task<Void, Never>? = nil
    @Published var currentLocationString: String = ""
    
    @Published var currentWeatherModel: CurrentWeatherModel = .init()
    @Published var todayPrecipitationModel: TodayPrecipitationModel = .init()
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

extension MainWeatherViewModel {
    private func observeAuthorizationStatus() async {
        do {
            for try await newStatus in LocationManager.shared.authorizationStatusStream {
                self.authorizationStatus = newStatus
            }
        } catch {
            if let locationError = error as? LocationError {
                // TODO: handle error
                print("error: \(locationError)")
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
        case .failure(let failure):
            print("Error: \(failure)")
        }
    }
}

extension MainWeatherViewModel {
    func getCurrentWeather() async {
        isLoading = true
        let result = await WeatherManager.shared.getCurrentWeather(location: currentLocation)
        switch result {
        case .success(let data):
            print("jaebi: current weather \(data)")
            currentWeatherModel = data
        case .failure(let failure):
            print("Error: \(failure)")
        }
        isLoading = false
    }
    
    func getTodayPrecipitationPercentage() async {
        isLoading = true
        let result = await WeatherManager.shared.getHourlyPrecipitation(location: currentLocation)
        switch result {
        case .success(let data):
            todayRainPercentage = data.first?.toPercentage() ?? ""
        case .failure(let failure):
            print("Error: \(failure)")
        }
        isLoading = false
    }
    
    func getTemperaturePrecipitationChange() async {
        
    }
    
    func getWeather() async {
        isLoading = true
//        let result = await WeatherManager.shared.getWeather(location: currentLocation)
//        switch result {
//        case .success(let weatherData):
//            print("\(weatherData)")
//        case .failure(let failure):
//            print("Error: \(failure)")
//        }
        isLoading = false
    }
}

enum GeocodeError: Error {
    case invalidPlacemark
    case invalidCity
    case invalidCountry
    case reverseGeocodeFailure
}
