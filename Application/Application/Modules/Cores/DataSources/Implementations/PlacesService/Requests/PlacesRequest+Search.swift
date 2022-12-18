import Foundation

extension SearchPlacesRequest {
    var parameters: HTTPRequestParameters {
        .urlQuery(
            [
                "ll": "\(latitude),\(longitude)",
                "radius": "\(radius)"
            ]
        )
    }
}

struct SearchPlacesResponse: Decodable {
    typealias Result = FoursquarePlace
    let results: [Result]
}
