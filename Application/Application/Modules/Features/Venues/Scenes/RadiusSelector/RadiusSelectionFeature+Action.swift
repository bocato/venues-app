import ComposableArchitecture
import CoreLocation
import Dependencies
import SwiftUI
import TCABoundaries

extension RadiusSelectionFeature {
    // MARK: - Actions
    
    enum Action: TCAFeatureAction, Equatable {
        enum ViewAction: Equatable {
            case applyButtonTapped
            case decrementRadiusTapped
            case radiusValueChanged(Double)
            case incrementRadiusTapped
        }
        
        enum InternalAction: Equatable {}
        
        enum DelegateAction: Equatable {
            case applyRadiusValue(Int)
        }
        
        case view(ViewAction)
        case _internal(InternalAction)
        case delegate(DelegateAction)
    }
}
