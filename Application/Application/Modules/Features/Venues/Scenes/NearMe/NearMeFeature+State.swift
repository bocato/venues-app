import ComposableArchitecture
import CoreLocation
import Dependencies
import SwiftUI
import TCABoundaries

extension NearMeFeature {
    // MARK: - State
    struct State: Equatable {
        var viewStage: ViewStage = .loading
        var searchRadius: Int = .defaultSearchRadius
    }
}
extension NearMeFeature.State {
    enum ViewStage: Equatable {
        case loading
        case noLocation
        case venuesLoaded([VenueCardModel])
        case error // TODO: Add Error Model
    }
}

private extension Int {
    static let defaultSearchRadius = 3000 // 3km
}
