import Foundation
import CoreLocation
import Combine

final class LocationManagerDelegate: NSObject, CLLocationManagerDelegate {
    typealias Event = LocationManager.DelegateEvent
    // MARK: - Properties
    
    private let subject: PassthroughSubject<Event, Never>
    
    // MARK: - Initialization
    
    init(subject: PassthroughSubject<Event, Never>) {
        self.subject = subject
    }
    
    // MARK: - CLLocationManagerDelegate
    
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        subject.send(.didChangeAuthorization(status))
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        subject.send(.didUpdateLocations(locations))
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        subject.send(.didFailWithError(error))
    }
}
