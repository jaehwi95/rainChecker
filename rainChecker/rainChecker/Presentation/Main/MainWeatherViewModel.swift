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
    let currentLocation: CLLocation = CLLocation.seoul
    @Published var currentWeatherModel: CurrentWeatherModel = .init()
}

extension MainWeatherViewModel {
    func getCurrentWeather() async {
        isLoading = true
        let result = await WeatherManager.shared.getCurrentWeather(location: currentLocation)
        switch result {
        case .success(let data):
            currentWeatherModel = data
        case .failure(let failure):
            print("Error: \(failure)")
        }
        isLoading = false
    }
    
    func getTodayPrecipitationPercentage() async {
        
    }
    
    func getTemperaturePrecipitationChange() async {
        
    }
    
    func getWeather() async {
        isLoading = true
        let result = await WeatherManager.shared.getWeather(location: currentLocation)
        switch result {
        case .success(let weatherData):
            print("\(weatherData)")
        case .failure(let failure):
            print("Error: \(failure)")
        }
        isLoading = false
    }
}
