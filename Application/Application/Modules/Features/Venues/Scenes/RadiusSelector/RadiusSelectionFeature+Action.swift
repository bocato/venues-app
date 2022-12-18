import ComposableArchitecture
import CoreLocation
import Dependencies
import SwiftUI
import TCABoundaries

extension RadiusSelectionFeature {
    // MARK: - Actions
    
    enum Action: TCAFeatureAction, Equatable {
        enum ViewAction: Equatable {
            case decrementRadiusTapped
            case radiusValueChanged(Int)
            case incrementRadiusTapped
        }
        
        enum InternalAction: Equatable {}
        
        enum DelegateAction: Equatable {}
        
        case view(ViewAction)
        case _internal(InternalAction)
        case delegate(DelegateAction)
    }
}
