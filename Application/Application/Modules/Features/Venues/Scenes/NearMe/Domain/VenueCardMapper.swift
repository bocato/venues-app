import Foundation

struct VenueCardMapper {
    let map: (FoursquarePlace) -> VenueCardModel
}
extension VenueCardMapper {
    static let live: Self = .init(map: map(from:))
    
    private static func map(from entity: FoursquarePlace) -> VenueCardModel {
        var imageURL: String = ""
        if let firstPhoto = entity.photos.first {
            imageURL = firstPhoto.prefix + String(firstPhoto.suffix.dropFirst())
        }
        
        let kind = entity.categories.compactMap { $0.name }.first ?? ""
        
        var locationInfo = "\(entity.distance)m"
        if let neighborhood = entity.location.neighborhood?.first {
            locationInfo += " | " + neighborhood
        }
        
        return .init(
            id: entity.fsqID,
            imageURL: imageURL,
            name: entity.name,
            kind: kind,
            locationInfo: locationInfo,
            score: entity.rating,
            description: "bla bla bla"
        )
    }
}


// MARK: - TCA Dependency Injection

import Dependencies

extension VenueCardMapper: DependencyKey {
    static var liveValue: VenueCardMapper = .live
}

extension DependencyValues {
    var venueCardMapper: VenueCardMapper {
        get { self[VenueCardMapper.self] }
        set { self[VenueCardMapper.self] = newValue }
    }
}

