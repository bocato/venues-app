import SwiftUI

struct VenueCardModel: Equatable, Identifiable, Hashable {
    let id: String
    let imageURL: String
    let name: String
    let kind: String // type of place... like: Gym/Fitness or Asian $$$$ (type or type + price range)
    let locationInfo: String // 250m Ijburg West (distance + region)
    let score: Double
    let comment: String?
}

#if DEBUG
extension VenueCard.Model {
    static let mockWithComment: Self = .fixture(
        comment: "User comment about the venue."
    )
    static func fixture(
        id: String = "id123",
        imageURL: String = "https://fastly.4sqi.net/img/user/176x176/145930472-SUFRN4KCNVGTIZRZ.jpg",
        name: String = "1. Crossfit 123",
        kind: String = "Gym/Fitness",
        locationInfo: String = "250m IJBurg West",
        score: Double = 8.5,
        comment: String? = nil
    ) -> Self {
        .init(
            id: id,
            imageURL: imageURL,
            name: name,
            kind: kind,
            locationInfo: locationInfo,
            score: score,
            comment: comment
        )
    }
}
#endif
