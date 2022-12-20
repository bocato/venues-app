import Foundation
import CoreLocation
import Combine

public struct LocationManager {
    public typealias LocationCoordinate = CLLocationCoordinate2D
    public var authorizationStatus: () -> CLAuthorizationStatus
    public var requestWhenInUseAuthorization: () -> Void
    public var requestLocation: () -> Void
    public var lastLocationCoordinate: () -> LocationCoordinate?
    public var delegate: AnyPublisher<DelegateEvent, Never>
    
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
    #if DEBUG
    public static var testValue: LocationManager = .failing
    #endif
}

extension DependencyValues {
    public var locationManager: LocationManager {
        get { self[LocationManager.self] }
        set { self[LocationManager.self] = newValue }
    }
}

// MARK: - Test Support

#if DEBUG
import XCTestDynamicOverlay

extension LocationManager {
    public static let failing: Self = .init(
        authorizationStatus: {
            XCTFail("`authorizationStatus` was not implemented.")
            return .notDetermined
        },
        requestWhenInUseAuthorization: {
            XCTFail("`requestWhenInUseAuthorization` was not implemented.")
        },
        requestLocation: {
            XCTFail("`requestLocation` was not implemented.")
        },
        lastLocationCoordinate: {
            XCTFail("`lastLocationCoordinate` was not implemented.")
            return nil
        },
        delegate: .failing
    )
}

extension LocationManager.LocationCoordinate {
    public static func fixture(
        latitude: CLLocationDegrees = .zero,
        longitude: CLLocationDegrees = .zero
    ) -> Self {
        .init(
            latitude: latitude,
            longitude: longitude
        )
    }
}
#endif
