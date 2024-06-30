//
//  LocationError.swift
//  rainChecker
//
//  Created by Jaehwi Kim on 6/30/24.
//

import Foundation

enum LocationError: Error {
    case notAuthorized
    case invalidCurrentLocation
    case invalidCity
    case invalidCountry
    case failFetchCityCountry
}
