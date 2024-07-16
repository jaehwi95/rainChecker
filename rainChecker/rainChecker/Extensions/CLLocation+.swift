//
//  CLLocation+.swift
//  rainChecker
//
//  Created by Jaehwi Kim on 6/13/24.
//

import Foundation
import CoreLocation

extension CLLocation {
    static var seoul: CLLocation { CLLocation(latitude: 37.5519, longitude: 126.9918) }
}

extension CLLocationCoordinate2D {
    static var seoul: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 37.5519, longitude: 126.9918)
    static var sanFrancisco: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 37.7749, longitude: 122.4194)
}
