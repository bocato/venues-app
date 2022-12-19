import SwiftUI

struct VenueCardModel: Equatable, Identifiable, Hashable {
    let id: String
    let imageURL: String
    let name: String
    let kind: String?
    let locationInfo: String
    let rating: Double?
    let description: String?
}

#if DEBUG
extension VenueCard.Model {
    public static let mockImageURL = "https://fastly.4sqi.net/img/user/176x176/145930472-SUFRN4KCNVGTIZRZ.jpg"
    
    public static func fixture(
        id: String = "id123",
        imageURL: String = mockImageURL,
        name: String = "1. Crossfit 123",
        kind: String? = nil,
        locationInfo: String = "250m IJBurg West",
        rating: Double? = nil,
        description: String? = nil
    ) -> Self {
        .init(
            id: id,
            imageURL: imageURL,
            name: name,
            kind: kind,
            locationInfo: locationInfo,
            rating: rating,
            description: description
        )
    }
    
    
    
    public static let mockWithAllFields: Self = .fixture(
        kind: "Gym/Fitness",
        rating: 9.5,
        description: "User comment about the venue."
    )
    
    public static let mockWithRating: Self = .fixture(
        rating: 9.5
    )

    public static let mockWithKind: Self = .fixture(
        kind: "Gym/Fitness"
    )
    
    public static let mockWithDescription: Self = .fixture(
        description: "User comment about the venue."
    )
    
    public static let mockWithNoOptionalFields: Self = .fixture()
}
#endif
