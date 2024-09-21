//
//  CLAuthorizationStatus+Extension.swift
//  rainChecker
//
//  Created by Jaehwi Kim on 7/15/24.
//

import CoreLocation

extension CLAuthorizationStatus {
    var isAuthorized: Bool {
        switch self {
        case .authorizedAlways, .authorizedWhenInUse, .authorized:
            return true
        default:
            return false
        }
    }
}
