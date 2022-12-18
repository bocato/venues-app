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
    
    public func searchPlaces(_ request: SearchPlacesRequest) async throws -> [FoursquarePlace] {
        let request: PlacesRequest = .search(request)
        
        do {
            let response = try await dispatcher.asyncResponse(for: request) // TODO: - Better error handling
            do {
                let string = String(data: response.data, encoding: .utf8)
                let resultsValue = ((try! JSONSerialization.jsonObject(with: response.data)) as! [String: Any])["results"]
                let resultsArray = resultsValue as? [[String: Any]]
                print("")
                
                let decodedResponse = try jsonDecoder.decode(SearchPlacesResponse.self, from: response.data)
                let places = decodedResponse.results
                return places
            } catch {
                print(error)
                return []
            }
        } catch {
            print(error)
            return []
        }

//        let response = try await dispatcher.asyncResponse(for: request) // TODO: - Better error handling
//        let decodedResponse = try jsonDecoder.decode(SearchPlacesResponse.self, from: response.data)
//        let places = decodedResponse.results
//        return places
    }
}
