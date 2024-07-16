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
    @Published var todayRainPercentage: Double = 0.0
    
    @Published var isShowLocationSettingSheet: Bool = false
    @Published var inputCity: String = ""
    @Published var inputCountry: String = ""
    @Published var updatedLocation: CLLocation? = nil
    @Published var isShowCityCountryError: Bool = false
    
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
    func updateCurrentLocation() async {
        let result = await geocodeAddressFromString(locationString: "\(inputCity), \(inputCountry)")
        switch result {
        case .success(let data):
            self.isShowCityCountryError = false
            self.updatedLocation = CLLocation(latitude: data.coordinate.latitude, longitude: data.coordinate.longitude)
            self.currentLocationString = "\(data.city), \(data.country)"
            self.isShowLocationSettingSheet = false
        case .failure(let geocodeError):
            // TODO: handle error
            self.isShowCityCountryError = true
            print("GeocodeError: \(geocodeError)")
        }
    }
    
    private func geocodeAddressFromString(locationString: String) async -> Result<(city: String, country: String, coordinate: CLLocationCoordinate2D), GeocodeError> {
        do {
            let placeMarks: [CLPlacemark] = try await CLGeocoder().geocodeAddressString(locationString)
            if let placemark = placeMarks.first {
                guard let city = placemark.locality else {
                    return .failure(.invalidCity)
                }
                guard let country = placemark.country else {
                    return .failure(.invalidCountry)
                }
                guard let coordinate = placemark.location?.coordinate else {
                    return .failure(.invalidCoordinate)
                }
                return .success((city, country, coordinate))
            } else {
                return .failure(.invalidPlacemark)
            }
        } catch {
            return .failure(.reverseGeocodeFailure)
        }
    }
    
    func openSettings() async {
        // Create the URL that deep links to your app's custom settings.
        if let url = URL(string: UIApplication.openSettingsURLString) {
            // Ask the system to open that URL.
            await UIApplication.shared.open(url)
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
}

// Weather Logics
extension MainWeatherViewModel {
    func getCurrentWeather(location: CLLocation) async {
        let result = await WeatherManager.shared.getCurrentWeather(location: currentLocation)
        switch result {
        case .success(let data):
            currentWeatherModel = data
        case .failure(let failure):
            print("Current Weather Error: \(failure)")
        }
    }
    
    func getTodayWeatherForecast(location: CLLocation) async {
        let result = await WeatherManager.shared.getTodayWeatherForecast(location: currentLocation)
        switch result {
        case .success(let data):
            hourlyForecastModels = data
        case .failure(let failure):
            print("Today Weather Forecast Error: \(failure)")
        }
    }
    
    func getWeekWeatherForecast(location: CLLocation) async {
        let result = await WeatherManager.shared.getWeekWeatherForecast(location: currentLocation)
        switch result {
        case .success(let data):
            weeklyForecastModels = data
            todayRainPercentage = (weeklyForecastModels.first?.precipitationChance ?? 0.0)
        case .failure(let failure):
            print("Week Weather Forecast Error: \(failure)")
        }
    }
}
