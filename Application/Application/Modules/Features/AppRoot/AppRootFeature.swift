import ComposableArchitecture
import CoreLocation
import Dependencies
import SwiftUI
import TCABoundaries

struct AppRootFeature: ReducerProtocol {
    // MARK: - Dependencies
    
    @Dependency(\.locationManager) var locationManager
    
    // MARK: - Reducer Composition
    
    var body: some ReducerProtocol<State, Action> {
        Reduce(reduceAppRootFeature)
        Scope(state: \.nearMeTab, action: /Action.InternalAction.nearMeTab) {
            NearMeFeature()
        }
    }
    
    // MARK: - AppRoot Feature Handler
    
    private func reduceAppRootFeature(
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
        case .onAppear:
            return .init(value: ._internal(.requestLocationPermissions))
        case let .selectTab(tab):
            state.selectedTab = tab
            return .none
        }
    }
    
    // MARK: - Internal Actions Handler
    
    private func reduce(
        into state: inout State,
        internalAction action: Action.InternalAction
    ) -> EffectTask<Action> {
        switch action {
        // Internal Actions
        case .requestLocationPermissions:
            let status = locationManager.authorizationStatus()
            guard status.needsPermissionRequest else { return .none }
            return .fireAndForget {
                locationManager.requestWhenInUseAuthorization()
            }
        // Child Flows
        case let .nearMeTab(action):
            return reduceNearMeTab(
                into: &state,
                action: action
            )
        }
    }
    
    // MARK: - NearMe Tab Handler
    
    private func reduceNearMeTab(
        into state: inout State,
        action: NearMeFeature.Action
    ) -> EffectTask<Action> {
        guard case let .delegate(delegateAction) = action else { return .none } // we will only intercept delegate actions
        switch delegateAction {
        case .needsLocationPermission:
            return .init(value: ._internal(.requestLocationPermissions))
        }
    }
}

