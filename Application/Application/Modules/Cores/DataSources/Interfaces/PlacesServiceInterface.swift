import Foundation

public protocol PlacesServiceProtocol {
    func searchPlaces(_ request: SearchPlacesRequest) async throws -> [FoursquarePlace]
}

// MARK: - TCA Dependency Injection

import Dependencies

extension DependencyValues {
    private enum PlacesServiceKey: DependencyKey {
        typealias Value = PlacesServiceProtocol
        static var liveValue: PlacesServiceProtocol = PlacesService( // TODO: Add secondary DI system to decouple interface/implementation
            dispatcher: HTTPRequestDispatcher(),
            jsonDecoder: .init()
        )
    }
    
    public var placesService: PlacesServiceProtocol {
        get { self[PlacesServiceKey.self] }
        set { self[PlacesServiceKey.self] = newValue }
    }
}
