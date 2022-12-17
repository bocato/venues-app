import Foundation

public protocol PlacesServiceProtocol {
    func searchPlaces(_ request: SearchPlacesRequest) async throws -> Any
}
