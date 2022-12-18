import Foundation
import CoreLocation
import Combine

public extension LocationManager {
    static var live: Self {
        let locationManager: CLLocationManager = .init()
        
        let delegateSubject: PassthroughSubject<DelegateEvent, Never> = .init()
        var locationManagerDelegate: LocationManagerDelegate? = .init(subject: delegateSubject)
        locationManager.delegate = locationManagerDelegate
        
        let managerDelegate: AnyPublisher<DelegateEvent, Never> = delegateSubject
            .handleEvents(receiveCancel: { locationManagerDelegate = nil } )
            .eraseToAnyPublisher()
        
        return .init(
            authorizationStatus: { locationManager.authorizationStatus },
            requestWhenInUseAuthorization: locationManager.requestWhenInUseAuthorization,
            requestLocation: locationManager.requestLocation,
            lastLocation: { locationManager.location },
            delegate: managerDelegate
        )
    }
}
