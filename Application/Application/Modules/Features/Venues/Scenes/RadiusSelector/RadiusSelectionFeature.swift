import ComposableArchitecture
import CoreLocation
import Dependencies
import SwiftUI
import TCABoundaries

struct RadiusSelectionFeature: ReducerProtocol {
    // MARK: - Dependencies
    
    // MARK: - Logic
    
    func reduce(
        into state: inout State,
        action: Action
    ) -> EffectTask<Action> {
        switch action {
        case let .view(action):
            return reduce(
                into: &state,
                viewAction: action
            )
        case let ._internal(action):
            return reduce(
                into: &state,
                internalAction: action
            )
        case .delegate:
            return .none
        }
    }
    
    // MARK: - View Actions Handler
    
    private func reduce(
        into state: inout State,
        viewAction action: Action.ViewAction
    ) -> EffectTask<Action> {
        switch action {
        case .decrementRadiusTapped:
            state.radiusValue += 1
            return .none
            
        case let .radiusValueChanged(value):
            state.radiusValue = value
            return .none
        
        case .incrementRadiusTapped:
            state.radiusValue -= 1
            return .none
        }
    }
    
    // MARK: - Internal Actions Handler
    
    private func reduce(
        into state: inout State,
        internalAction action: Action.InternalAction
    ) -> EffectTask<Action> {
        switch action {
        
        }
    }
}
