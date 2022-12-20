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

// MARK: - Test Support
#if DEBUG
public final class PlacesServiceStub: PlacesServiceProtocol {
    public init() {}
    
    public var searchPlacesResultToBeReturned: Result<[FoursquarePlace], Error> = .success([])
    public func searchPlaces(_ request: SearchPlacesRequest) async throws -> [FoursquarePlace] {
        switch searchPlacesResultToBeReturned {
        case let .success(places):
            return places
        case let .failure(error):
            throw error
        }
    }
}

public struct PlacesServiceDummy: PlacesServiceProtocol {
    public init() {}
    
    public func searchPlaces(_ request: SearchPlacesRequest) async throws -> [FoursquarePlace] {
        return []
    }
}
#endif
