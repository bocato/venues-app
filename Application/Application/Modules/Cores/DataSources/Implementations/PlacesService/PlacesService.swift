import Foundation

public struct PlacesService: PlacesServiceProtocol {
    // MARK: - Dependencies
    
    private let dispatcher: HTTPRequestDispatcherProtocol
    private let jsonDecoder: JSONDecoder
    
    // MARK: - Initialization
    
    init(
        dispatcher: HTTPRequestDispatcherProtocol,
        jsonDecoder: JSONDecoder
    ) {
        self.dispatcher = dispatcher
        self.jsonDecoder = jsonDecoder
    }
    
    // MARK: - Public API
    
    public func searchPlaces(_ request: SearchPlacesRequest) async throws -> Any {
        let request: PlacesRequest = .search(request)
        let rawResponse = try await dispatcher.asyncResponse(for: request)
        return rawResponse
    }
}
