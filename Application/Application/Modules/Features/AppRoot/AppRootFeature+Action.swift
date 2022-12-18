import ComposableArchitecture
import CoreLocation
import Dependencies
import SwiftUI
import TCABoundaries

extension AppRootFeature {
    // MARK: - Actions
    
    enum Action: TCAFeatureAction, Equatable {
        enum ViewAction: Equatable {
            case onAppear
            case selectTab(State.Tab)
        }
        
        enum InternalAction: Equatable {
            case requestLocationPermissions
            // Child Flows
            case nearMeTab(NearMeFeature.Action)
        }
        
        enum DelegateAction: Equatable {}
        
        case view(ViewAction)
        case _internal(InternalAction)
        case delegate(DelegateAction)
        
    }
}
