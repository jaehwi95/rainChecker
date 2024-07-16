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
    
    private let locationManager: CLLocationManager = CLLocationManager()

    @Published var currentLocation: CLLocation?
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    
    private var authorizationStatusContinuation: AsyncThrowingStream<CLAuthorizationStatus, Error>.Continuation?
    var authorizationStatusStream: AsyncThrowingStream<CLAuthorizationStatus, Error> {
        AsyncThrowingStream { continuation in
            self.authorizationStatusContinuation = continuation
            continuation.yield(self.authorizationStatus)
        }
    }
    
    private override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.authorizationStatus = locationManager.authorizationStatus
    }
    
    func requestLocationPermission() {
        self.locationManager.requestWhenInUseAuthorization()
    }
}

extension LocationManager {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        self.authorizationStatus = manager.authorizationStatus
        switch manager.authorizationStatus {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .restricted:
            print("Location Restricted")
            authorizationStatusContinuation?.finish(throwing: LocationError.restricted)
        case .denied:
            print("Location Denied")
            authorizationStatusContinuation?.finish(throwing: LocationError.denied)
        case .authorizedAlways, .authorizedWhenInUse, .authorized:
            print("Location Authorized")
            authorizationStatusContinuation?.yield(manager.authorizationStatus)
            self.currentLocation = manager.location
        @unknown default:
            print("Location Unknown error")
            authorizationStatusContinuation?.finish(throwing: LocationError.unknown)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // last element is the most recent location
        if let lastLocation = locations.last {
            currentLocation = lastLocation
        }
    }
}
