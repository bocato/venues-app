import SwiftUI

struct VenueCardModel: Equatable {
    let imageURL: String
//    let title: String
//    let subtitle: String
    let score: Double
    let comment: String
}

#if DEBUG
extension VenueCard.Model {
    static let mock: Self = .fixture()
    static func fixture(
        imageURL: String = "https://fastly.4sqi.net/img/user/176x176/145930472-SUFRN4KCNVGTIZRZ.jpg",
        score: Double = 8.5,
        comment: String = "User comment about the venue."
    ) -> Self {
        .init(imageURL: imageURL, score: score, comment: comment)
    }
}
#endif
