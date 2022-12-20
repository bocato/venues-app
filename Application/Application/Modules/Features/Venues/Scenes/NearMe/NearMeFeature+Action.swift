import ComposableArchitecture
import CoreLocation
import Dependencies
import SwiftUI
import TCABoundaries

extension NearMeFeature {
    // MARK: - Actions
    
    enum Action: TCAFeatureAction, Equatable {
        enum ViewAction: Equatable {
            case onAppear
            case requestLocationPermissionsButtonTapped
            case onRetryButtonTapped
            case onPullToRefresh
            case onRadiusButtonTapped
            case dismissRadiusSheet
            case onDisappear
        }
        
        enum InternalAction: Equatable {
            case observeLocationUpdates
            case handleLocationManagerEvent(LocationManager.DelegateEvent)
            case loadVenuesUsingCurrentLocation
            case loadVenues(SearchPlacesRequest)
            case searchPlacesResult(TaskResult<[FoursquarePlace]>)
            // Child Flows
            case radiusSelection(RadiusSelectionFeature.Action)
        }
        
        enum DelegateAction: Equatable {
            case needsLocationPermission
        }
        
        case view(ViewAction)
        case _internal(InternalAction)
        case delegate(DelegateAction)
    }
}
