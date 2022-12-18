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
            let needsPermissionRequest = locationManager.authorizationStatus().needsPermissionRequest
            guard !needsPermissionRequest else {
                state.viewStage = .noLocation
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
            
        case .onErrorRetryButtonTapped:
            return .init(value: ._internal(.loadVenuesUsingCurrentLocation))
            
        case .onPullToRefresh:
            return .init(value: ._internal(.loadVenuesUsingCurrentLocation))
        }
    }
    
    // MARK: - Internal Actions Handler
    
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
            
        case let .handleLocationManagerEvent(event):
            switch event {
            case .didChangeAuthorization, .didFailWithError:
                return .none // TODO: add specific messages for failure or when permissions are still not enough
            case let .didUpdateLocations(locations):
                let needsPermissionRequest = locationManager.authorizationStatus().needsPermissionRequest
                guard
                    !needsPermissionRequest,
                    let coordinate = locations.last?.coordinate
                else { return .none }
                
                let request: SearchPlacesRequest = .init(
                    latitude: coordinate.latitude,
                    longitude: coordinate.longitude,
                    radius: state.searchRadius
                )
                return .init(value: ._internal(.loadVenues(request)))
            }
            
        case .loadVenuesUsingCurrentLocation:
            guard
                let coordinate = locationManager.lastLocation()?.coordinate
            else {
                state.viewStage = .noLocation
                return .none
            }
            let request: SearchPlacesRequest = .init(
                latitude: coordinate.latitude,
                longitude: coordinate.longitude,
                radius: state.searchRadius
            )
            return .init(value: ._internal(.loadVenues(request)))
            
        case let .loadVenues(request):
            return .task { [placesService] in
                let result: TaskResult<[FoursquarePlace]>
                do {
                    let values = try await placesService.searchPlaces(request)
                    result = .success(values)
                } catch {
                    result = .failure(error)
                }
                return ._internal(.searchPlacesResult(result))
            }
            
        case let .searchPlacesResult(.success(venues)):
            let mapCards = venueCardMapper.map
            let cards = venues.map(mapCards)
            state.viewStage = .venuesLoaded(cards)
            return .none
            
        case .searchPlacesResult(.failure):
            state.viewStage = .error
            return .none
        }
    }
}
