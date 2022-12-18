import Foundation

public struct FoursquarePlace: Decodable {
    public let fsqID: String
    public let categories: [Category]
    public let distance: Int
    public let link: String
    public let location: Location
    public let name: String
    
    enum CodingKeys: String, CodingKey {
        case fsqID = "fsq_id"
        case categories, distance, link, location, name
    }
}

public extension FoursquarePlace {
    struct Category: Decodable {
        public let id: Int
        public let name: String
    }
    
    struct Location: Decodable {
        public let address: String
        public let country: String
        public let formattedAddress: String
        public let neighborhood: [String]?
        public let postcode: String
        public let addressExtended: String?

        enum CodingKeys: String, CodingKey {
            case address
            case country
            case formattedAddress = "formatted_address"
            case neighborhood, postcode
            case addressExtended = "address_extended"
        }
    }
}
