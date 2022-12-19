import Foundation

struct VenueCardMapper {
    let map: (FoursquarePlace) -> VenueCardModel
}
extension VenueCardMapper {
    static let live: Self = .init(map: map(from:))
    
    private static func map(from entity: FoursquarePlace) -> VenueCardModel {
        var imageURL: String = ""
        if let firstPhoto = entity.photos.first {
            let resolution = "176x176" // force smaller, but could use (width x height)
            imageURL = firstPhoto.prefix + resolution + firstPhoto.suffix
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
            rating: entity.rating,
            description: entity.description
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

