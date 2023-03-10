import ComposableArchitecture
import CoreLocation
import Dependencies
import SwiftUI
import TCABoundaries

struct NearMeFeature: ReducerProtocol {
    // MARK: - Dependencies
    
    @Dependency(\.locationManager) var locationManager
    @Dependency(\.placesService) var placesService
    @Dependency(\.venueCardMapper) var venueCardMapper
    @Dependency(\.mainQueue) var mainQueue
    
    // MARK: - Reducer Composition
    
    var body: some ReducerProtocol<State, Action> {
        Reduce(reduceNearMeFeature)
            .ifLet(\.radiusSelectionState, action: /Action.InternalAction.radiusSelection) {
                RadiusSelectionFeature()
            }
    }
    
    // MARK: - Logic
    
    func reduceNearMeFeature(
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
        case .delegate: // Delegates are handled by the parent
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
            let status = locationManager.authorizationStatus()
            guard status.needsPermissionRequest == false else {
                state.viewStage = .error(.noLocationPermission)
                return .concatenate(
                    .init(value: .delegate(.needsLocationPermission)),
                    .init(value: ._internal(.observeLocationUpdates))
                )
            }
            return .init(value: ._internal(.loadVenuesUsingCurrentLocation))
            
        case .requestLocationPermissionsButtonTapped:
            return .concatenate(
                .init(value: .delegate(.needsLocationPermission)),
                .init(value: ._internal(.observeLocationUpdates))
            )
            
        case .onRetryButtonTapped:
            return .init(value: ._internal(.loadVenuesUsingCurrentLocation))
            
        case .onPullToRefresh:
            return .init(value: ._internal(.loadVenuesUsingCurrentLocation))
            
        case .onRadiusButtonTapped:
            state.route = .radiusScene
            let radiusValue = Double(state.searchRadius)
            state.radiusSelectionState = .init(radiusValue: radiusValue)
            return .none
            
        case .dismissRadiusSheet:
            state.route = nil
            return .none
            
        case .onDisappear:
            return .cancel(id: LocationManagerObservationID.self)
        }
    }
    
    // MARK: - Internal Actions Handler
    
    private enum LocationManagerObservationID {}
    
    private func reduce(
        into state: inout State,
        internalAction action: Action.InternalAction
    ) -> EffectTask<Action> {
        switch action {
        case .observeLocationUpdates:
            return locationManager
                .delegate
                .receive(on: mainQueue)
                .eraseToEffect()
                .map { ._internal(.handleLocationManagerEvent($0)) }
                .cancellable(id: LocationManagerObservationID.self)
            
        case let .handleLocationManagerEvent(event):
            switch event {
            case let .didChangeAuthorization(auth):
                guard auth.needsPermissionRequest == false else {
                    state.viewStage = .error(.noLocationPermission)
                    return .none
                }
                return .init(value: ._internal(.loadVenuesUsingCurrentLocation))
                
            case .didFailWithError:
                state.viewStage = .error(.locationManagerFailed)
                return .none
                
            case let .didUpdateLocations(locations):
                guard let coordinate = locations.last?.coordinate else {
                    state.viewStage = .error(.noValidLocation)
                    return .none
                }
                let request: SearchPlacesRequest = .init(
                    latitude: coordinate.latitude,
                    longitude: coordinate.longitude,
                    radius: state.searchRadius
                )
                return .init(value: ._internal(.loadVenues(request)))
            }
            
        case .loadVenuesUsingCurrentLocation:
            guard let coordinate = locationManager.lastLocationCoordinate() else {
                return .concatenate(
                    .fireAndForget { locationManager.requestLocation() },
                    .init(value: ._internal(.observeLocationUpdates))
                )
            }
            let request: SearchPlacesRequest = .init(
                latitude: coordinate.latitude,
                longitude: coordinate.longitude,
                radius: state.searchRadius
            )
            return .init(value: ._internal(.loadVenues(request)))
            
        case let .loadVenues(request):
            state.viewStage = .loading
            return .task { @MainActor [placesService] in
                let result: TaskResult<[FoursquarePlace]>
                do {
                    let values = try await placesService.searchPlaces(request)
                    result = .success(values)
                } catch {
                    result = .failure(error)
                }
                return ._internal(.searchPlacesResult(result))
            }
            .receive(on: mainQueue)
            .eraseToEffect()
            
        case let .searchPlacesResult(.success(venues)):
            let mapCards = venueCardMapper.map
            let cards = venues.map(mapCards)
            state.viewStage = .venuesLoaded(cards)
            return .none
            
        case .searchPlacesResult(.failure):
            state.viewStage = .error(.serviceError)
            return .none
            
        // Child Flows
        case let .radiusSelection(action):
            return reduceRadiusSelectionScene(
                into: &state,
                action: action
            )
        }
    }
    
    // MARK: - Child Flows
    
    private func reduceRadiusSelectionScene(
        into state: inout State,
        action: RadiusSelectionFeature.Action
    ) -> EffectTask<Action> {
        guard case let .delegate(delegateAction) = action else { return .none } // we will only intercept delegate actions
        switch delegateAction {
        case let .applyRadiusValue(radius):
            state.searchRadius = radius
            return .concatenate(
                .init(value: .view(.dismissRadiusSheet)),
                .init(value: ._internal(.loadVenuesUsingCurrentLocation))
            )
        }
    }
}
