//
//  LocationManager.swift
//  rainChecker
//
//  Created by Jaehwi Kim on 6/15/24.
//

import Foundation
import CoreLocation

final class LocationManager: NSObject, CLLocationManagerDelegate {
    public static let shared = LocationManager()
    private let locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    
    private override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.startUpdatingHeading()
    }
    
    func requestAuthorization() {
        self.locationManager.requestWhenInUseAuthorization()
    }
    
    func fetchCityCountry() async -> Result<(city: String, country: String), LocationError> {
        do {
            switch locationManager.authorizationStatus {
            case .authorizedAlways, .authorizedWhenInUse, .authorized:
                guard let location = currentLocation else {
                    return .failure(.invalidCurrentLocation)
                }
                let placeMarks: [CLPlacemark] = try await CLGeocoder().reverseGeocodeLocation(location)
                guard let city = placeMarks.first?.locality else {
                    return .failure(.invalidCity)
                }
                guard let country = placeMarks.first?.country else {
                    return .failure(.invalidCountry)
                }
                return .success((city, country))
            default:
                return .failure(.notAuthorized)
            }
        } catch {
            return .failure(.failFetchCityCountry)
        }
    }
}

extension LocationManager {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        locationManager.startUpdatingLocation()
        switch locationManager.authorizationStatus {
        case .authorizedWhenInUse:
            print("location authoried when in use")
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            print("Location Restricted")
        case .denied:
            print("Location Denied")
        case .authorizedAlways:
            print("Location authorizedAlways")
        case .authorized:
            print("location authoried")
        @unknown default:
            print("unknown")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.first
    }
}

