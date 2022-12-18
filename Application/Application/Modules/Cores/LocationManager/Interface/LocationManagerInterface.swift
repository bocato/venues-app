import Foundation
import CoreLocation
import Combine

public struct LocationManager {
    public internal(set) var authorizationStatus: () -> CLAuthorizationStatus
    public internal(set) var requestWhenInUseAuthorization: () -> Void
    public internal(set) var requestLocation: () -> Void
    public internal(set) var lastLocation: () -> CLLocation?
    public internal(set) var delegate: AnyPublisher<DelegateEvent, Never>
    
    public enum DelegateEvent: Equatable {
        case didChangeAuthorization(CLAuthorizationStatus)
        case didUpdateLocations([CLLocation])
        case didFailWithError(Error)
        
        public static func == (lhs: Self, rhs: Self) -> Bool {
            switch (lhs, rhs) {
            case let (.didChangeAuthorization(l), .didChangeAuthorization(r)):
                return l == r
            case let (.didUpdateLocations(l), .didUpdateLocations(r)):
                return l == r
            case let (.didFailWithError(l), .didFailWithError(r)):
                return l as NSError == r as NSError
            default:
                return false
            }
        }
    }
}

public extension CLAuthorizationStatus {
    var needsPermissionRequest: Bool {
        self == .restricted || self == .denied || self == .notDetermined
    }
}

// MARK: - TCA Dependency Injection

import Dependencies

extension LocationManager: DependencyKey {
    public static var liveValue: LocationManager = .live // TODO: Add secondary DI system to decouple interface/implementation
}

extension DependencyValues {
    public var locationManager: LocationManager {
        get { self[LocationManager.self] }
        set { self[LocationManager.self] = newValue }
    }
}

