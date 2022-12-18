import Foundation

public struct SearchPlacesRequest: Equatable {
    // The latitude/longitude around which to retrieve place information. This must be specified as latitude,longitude (e.g., ll=41.8781,-87.6298).
    public let latitude: Double
    public let longitude: Double
    // Defines the distance (in meters) within which to bias place results. The maximum allowed radius is 100,000 meters. Radius is used with ll or ip biased geolocation only.
    public let radius: Int
}
