import Foundation

extension SearchPlacesRequest {
    private var formattedLat: String {
        .init(format: "%.4f", latitude)
    }
    
    private var formattedLong: String {
        .init(format: "%.4f", longitude)
    }
    
    private var fields: String {
        SearchPlacesResponse.Result.CodingKeys.allCases
            .map { $0.rawValue }
            .joined(separator: ",")
    }
    
    var parameters: HTTPRequestParameters {
        .urlQuery(
            [
                "ll": "\(formattedLat),\(formattedLong)",
                "radius": "\(radius)",
                "fields": fields
            ]
        )
    }
}

struct SearchPlacesResponse: Decodable {
    typealias Result = FoursquarePlace
    let results: [Result]
}
