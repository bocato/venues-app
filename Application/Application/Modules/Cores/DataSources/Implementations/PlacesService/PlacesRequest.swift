import Foundation

enum PlacesRequest: HTTPRequestProtocol {
    case search(SearchPlacesRequest)
}

extension PlacesRequest {
    var baseURL: URL {
        .init(string: "https://api.foursquare.com/v3/places")!
    }
    
    var path: String {
        switch self {
        case .search:
            return "search"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .search:
            return .get
        }
    }
    
    var parameters: HTTPRequestParameters {
        switch self {
        case let .search(request):
            return request.parameters
        }
    }
    
    var headers: [String: String]? {
        [
            "accept": "application/json",
            "Authorization": "fsq3YBopDFyitAKNEQaaZexNnNHIJeQQDZZ6Fxw5JGoxMbQ=" // TODO: Store this in a better place...
        ]
    }
}
