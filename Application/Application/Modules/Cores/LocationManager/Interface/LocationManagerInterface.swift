import Foundation
import CoreLocation
import Combine

public struct LocationManager {
    public internal(set) var authorizationStatus: () -> CLAuthorizationStatus
    public internal(set) var requestWhenInUseAuthorization: () -> Void
    public internal(set) var requestLocation: () -> Void
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
