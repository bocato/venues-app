import Foundation

public struct FoursquarePlace: Decodable, Equatable, Sendable { // Ideally I could also have a Domain model, but we won't do that this time
    public let fsqID: String
    public let categories: [Category]
    public let distance: Int
    public let link: String
    public let location: Location
    public let name: String
    public let rating: Double?
    public let photos: [Photo]
    public let description: String?
    
    enum CodingKeys: String, CodingKey, CaseIterable {
        case fsqID = "fsq_id"
        case categories, distance, link, location, name, rating, photos, description
    }
}

public extension FoursquarePlace {
    struct Category: Decodable, Equatable, Sendable {
        public let id: Int
        public let name: String
    }
    
    struct Location: Decodable, Equatable, Sendable {
        public let address: String?
        public let country: String
        public let formattedAddress: String
        public let neighborhood: [String]?
        public let postcode: String?
        public let addressExtended: String?

        enum CodingKeys: String, CodingKey {
            case address
            case country
            case formattedAddress = "formatted_address"
            case neighborhood, postcode
            case addressExtended = "address_extended"
        }
    }
    
    struct Photo: Decodable, Equatable, Sendable {
        public let id: String
        public let prefix: String
        public let suffix: String
        public let width: Int
        public let height: Int
    }
}
