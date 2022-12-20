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
        public let country: String
        public let formattedAddress: String
        public let neighborhood: [String]?

        enum CodingKeys: String, CodingKey {
            case country
            case formattedAddress = "formatted_address"
            case neighborhood
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

// MARK: - Test Support

#if DEBUG
extension FoursquarePlace {
    public static func fixture(
        fsqID: String = "557f12cf498e2f025de8c7d0",
        categories: [Category] = [.fixture()],
        distance: Int = 79,
        link: String = "/v3/places/557f12cf498e2f025de8c7d0",
        location: Location = .fixture(),
        name: String = "Picturehouse Central",
        rating: Double? = 9.4,
        photos: [Photo] = [.fixture()],
        description: String? = "It's a picture place!"
    ) -> Self {
        .init(
            fsqID: fsqID,
            categories: categories,
            distance: distance,
            link: link,
            location: location,
            name: name,
            rating: rating,
            photos: photos,
            description: description
        )
    }
}

extension FoursquarePlace.Category {
    public static func fixture(
        id: Int = 10024,
        name: String = "Cinema"
    ) -> Self {
        .init(id: id, name: name)
    }
}

extension FoursquarePlace.Location {
    public static func fixture(
        country: String = "GB",
        formattedAddress: String = "Shaftesbury Ave (Great Windmill St), Soho, Greater London, W1D 7DH",
        neighborhood: [String]? = ["Greater London"]
    ) -> Self {
        .init(
            country: country,
            formattedAddress: formattedAddress,
            neighborhood: neighborhood
        )
    }
}

extension FoursquarePlace.Photo {
    public static func fixture(
        id: String = "56c1dd6bcd10dc6dbc689615",
        prefix: String = "https://fastly.4sqi.net/img/general/",
        suffix: String = "/585636_aIdMlY9-tnXaVSSiwhM1qd1Om7iqj1Ln4Z7meUc4f98.jpg",
        width: Int = 720,
        height: Int = 960
    ) -> Self {
        .init(
            id: id,
            prefix: prefix,
            suffix: suffix,
            width: width,
            height: height
        )
    }
}

extension Array where Element == FoursquarePlace {
    static let threePlacesMock: Self = [
        .fixture(name: "Place 1"),
        .fixture(name: "Place 2"),
        .fixture(name: "Place 3")
    ]
}
#endif
