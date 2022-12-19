import ComposableArchitecture
import CoreLocation
import Dependencies
import SwiftUI
import TCABoundaries

extension NearMeFeature {
    // MARK: - State
    struct State: Equatable {
        var viewStage: ViewStage = .loading
        var route: Route?
        var searchRadius: Int = .defaultSearchRadius
        // Child Flows
        var radiusSelectionState: RadiusSelectionFeature.State?
    }
}
extension NearMeFeature.State {
    enum ViewStage: Equatable {
        case loading
        case noLocationPermission
        case venuesLoaded([VenueCardModel])
        case empty
        case error // TODO: Add better error messages/types
    }
    
    enum Route: Equatable {
        case radiusScene
    }
}

private extension Int {
    static let defaultSearchRadius = 3000 // 3km
}
