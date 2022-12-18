import ComposableArchitecture
import CoreLocation
import Dependencies
import SwiftUI
import TCABoundaries

extension AppRootFeature {
    // MARK: - State
    struct State: Equatable {
        var selectedTab: Tab = .nearMe
        var nearMeTab: NearMeFeature.State = .init()
    }
}

extension AppRootFeature.State {
    enum Tab: Int, Equatable, Hashable, Identifiable {
        var id: Int { rawValue }
        
        case nearMe
        case list
        case history
        case me
    }
}
