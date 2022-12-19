import ComposableArchitecture
import CoreLocation
import Dependencies
import SwiftUI
import TCABoundaries

extension RadiusSelectionFeature {
    // MARK: - Actions
    
    enum Action: TCAFeatureAction, Equatable {
        enum ViewAction: Equatable {
            case textFieldValueChanged(String)
            case decrementRadiusTapped
            case radiusSliderValueChanged(Double)
            case incrementRadiusTapped
            case applyButtonTapped
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
