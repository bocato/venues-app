import SwiftUI

struct VenueCardModel: Equatable, Identifiable, Hashable {
    let id: String
    let imageURL: String
    let name: String
    let kind: String?
    let locationInfo: String
    let score: Double
    let description: String?
}

#if DEBUG
extension VenueCard.Model {
    static func fixture(
        id: String = "id123",
        imageURL: String = "https://fastly.4sqi.net/img/user/176x176/145930472-SUFRN4KCNVGTIZRZ.jpg",
        name: String = "1. Crossfit 123",
        kind: String? = nil,
        locationInfo: String = "250m IJBurg West",
        score: Double = 8.5,
        description: String? = nil
    ) -> Self {
        .init(
            id: id,
            imageURL: imageURL,
            name: name,
            kind: kind,
            locationInfo: locationInfo,
            score: score,
            description: description
        )
    }
    
    static let mockWithKind: Self = .fixture(
        kind: "Gym/Fitness"
    )
    
    static let mockWithDescription: Self = .fixture(
        description: "User comment about the venue."
    )
}
#endif
