import ComposableArchitecture
import CoreLocation
import Dependencies
import SwiftUI
import TCABoundaries

struct NearMeFeature: ReducerProtocol {
    // MARK: - State
    struct State: Equatable {}
    
    // MARK: - Actions
    
    enum Action: TCAFeatureAction, Equatable {
        enum ViewAction: Equatable {
            case onAppear
        }
        
        enum InternalAction: Equatable {
            case requestLocationPermissions
            case observeLocationUpdates
        }
        
        enum DelegateAction: Equatable {
            
        }
        
        case view(ViewAction)
        case _internal(InternalAction)
        case delegate(DelegateAction)
    }
    
    // MARK: - Dependencies
    
    @Dependency(\.locationManager) var locationManager
    @Dependency(\.placesService) var placesService
    
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
        case .onAppear:
            return .init(value: ._internal(.requestLocationPermissions))
        }
    }
    
    // MARK: - Internal Actions Handler
    
    private func reduce(
        into state: inout State,
        internalAction action: Action.InternalAction
    ) -> EffectTask<Action> {
        switch action {
        case .requestLocationPermissions:
            guard locationManager.authorizationStatus().needsPermissionRequest else { return .none }
            return .concatenate(
                .fireAndForget {
                    locationManager.requestLocation()
                },
                .init(value: ._internal(.observeLocationUpdates))
            )
            
        case .observeLocationUpdates:
            // TODO: Implement
            return .none
        }
    }
}

struct NearMeScene: View {
    let store: StoreOf<NearMeFeature>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            NavigationStack {
                List {
                    VenueCard(model: .mockWithComment)
                    VenueCard(model: .fixture())
                }
                .listRowSeparator(.visible)
                .listStyle(.inset)
                .navigationTitle("Near me")
                .onAppear { viewStore.send(.view(.onAppear)) }
            }
        }
    }
}

#if DEBUG
struct NearMeScene_Previews: PreviewProvider {
    static var previews: some View {
        NearMeScene(
            store: .init(
                initialState: .init(),
                reducer: NearMeFeature()
            )
        )
    }
}
#endif
