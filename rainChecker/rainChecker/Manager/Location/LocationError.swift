//
//  LocationError.swift
//  rainChecker
//
//  Created by Jaehwi Kim on 6/30/24.
//

import Foundation

enum LocationError: Error {
    case restricted
    case denied
    case unknown
    
//    var errorDescription: String {
//        switch self {
//        default:
//            return "unknown error"
//        }
//    }
}

enum GeocodeError: Error {
    case invalidPlacemark
    case invalidCity
    case invalidCountry
    case invalidCoordinate
    case reverseGeocodeFailure
}
