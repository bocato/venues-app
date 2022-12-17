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
