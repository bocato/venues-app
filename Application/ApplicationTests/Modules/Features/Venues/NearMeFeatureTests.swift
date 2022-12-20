@testable import Application
import Combine
import CoreLocation
import ComposableArchitecture
import XCTest

@MainActor
final class NearMeFeatureTests: XCTestCase {
    // MARK: - Properties
    
    private var initialState: NearMeFeature.State = .init()
    private var placesServiceStub: PlacesServiceStub = .init()
    
    // MARK: - User Flows / View Action Tests
    
    func test_onAppear_whenThereIsNoNeedForPermissionRequestsAndLocationIsAvailable_itShouldLoadVenues() async {
        // Given
        let sut = TestStore(
            initialState: initialState,
            reducer: NearMeFeature()
        )
        
        sut.dependencies.locationManager.authorizationStatus = {
            .authorizedWhenInUse
        }
        
        let mockLocation: LocationManager.LocationCoordinate = .fixture()
        sut.dependencies.locationManager.lastLocationCoordinate = {
            mockLocation
        }
        
        let searchPlacesRequestMock: SearchPlacesRequest = .init(
            latitude: mockLocation.latitude,
            longitude: mockLocation.longitude,
            radius: initialState.searchRadius
        )
        
        let placesMock: [FoursquarePlace] = .threePlacesMock
        placesServiceStub.searchPlacesResultToBeReturned = .success(placesMock)
        sut.dependencies.placesService = placesServiceStub
        
        sut.dependencies.mainQueue = .immediate
        
        let cardMapper: VenueCardMapper = .live
        sut.dependencies.venueCardMapper = cardMapper
        let expectedCards = placesMock.map { cardMapper.map($0) }
        
        // When
        await sut.send(.view(.onAppear))
        
        // Then
        await sut.receive(._internal(.loadVenuesUsingCurrentLocation))
        await sut.receive(._internal(.loadVenues(searchPlacesRequestMock)))
        await sut.receive(._internal(.searchPlacesResult(.success(placesMock)))) {
            $0.viewStage = .venuesLoaded(expectedCards)
        }
    }
    
    func test_onAppear_whenThereIsNeedForPermissionsRequest_itShouldAskForPermissions_thenObserveChangesAndLoadVenues() async {
        // Given
        let sut = TestStore(
            initialState: initialState,
            reducer: NearMeFeature()
        )
        
        sut.dependencies.locationManager.authorizationStatus = {
            .notDetermined
        }

        let locationManagerDelegateMock: PassthroughSubject<LocationManager.DelegateEvent, Never> = .init()
        sut.dependencies.locationManager.delegate = locationManagerDelegateMock.eraseToAnyPublisher()
        sut.dependencies.mainQueue = .immediate

        let mockLocation: LocationManager.LocationCoordinate = .fixture()
        sut.dependencies.locationManager.lastLocationCoordinate = {
            mockLocation
        }

        let searchPlacesRequestMock: SearchPlacesRequest = .init(
            latitude: mockLocation.latitude,
            longitude: mockLocation.longitude,
            radius: initialState.searchRadius
        )

        let placesMock: [FoursquarePlace] = .threePlacesMock
        placesServiceStub.searchPlacesResultToBeReturned = .success(placesMock)
        sut.dependencies.placesService = placesServiceStub

        let cardMapper: VenueCardMapper = .live
        sut.dependencies.venueCardMapper = cardMapper
        let expectedCards = placesMock.map { cardMapper.map($0) }

        // When
        await sut.send(.view(.onAppear)) {
            $0.viewStage = .error(.noLocationPermission)
        }

        // Then
        await sut.receive(.delegate(.needsLocationPermission))
        await sut.receive(._internal(.observeLocationUpdates))

        locationManagerDelegateMock.send(.didChangeAuthorization(.authorizedWhenInUse))
        await sut.receive(._internal(.handleLocationManagerEvent(.didChangeAuthorization(.authorizedWhenInUse))))

        await sut.receive(._internal(.loadVenuesUsingCurrentLocation))
        await sut.receive(._internal(.loadVenues(searchPlacesRequestMock))) {
            $0.viewStage = .loading
        }
        await sut.receive(._internal(.searchPlacesResult(.success(placesMock)))) {
            $0.viewStage = .venuesLoaded(expectedCards)
        }
        
        // To cancel long living effects like the delegate observation
        await sut.send(.view(.onDisappear))
        await sut.finish()
    }
    
    func test_requestLocationPermissionsButtonTapped_shouldDelegateLocationPermissionRequestAndStartObservingLocationUpdates() async {
        // Given
        let sut = TestStore(
            initialState: initialState,
            reducer: NearMeFeature()
        )
        
        // We don't need to cover the whole flow, just be sure that the correct actions are called,
        // since the subsequent actions are is covered by other actions so we don't need exhaustivity this time.
        sut.exhaustivity = .off
        
        sut.dependencies.mainQueue = .immediate
        
        sut.dependencies.locationManager.delegate = Empty().eraseToAnyPublisher() // Dummy
        
        // When
        await sut.send(.view(.requestLocationPermissionsButtonTapped))
        
        // Then
        await sut.receive(.delegate(.needsLocationPermission))
        await sut.receive(._internal(.observeLocationUpdates))
        
        await sut.finish(timeout: .microseconds(1)) // Stop observing long living effects
    }
    
    func test_onRetryButtonTapped_shouldTryToLoadVenuesUsingCurrentLocation() async {
        // Given
        let sut = TestStore(
            initialState: initialState,
            reducer: NearMeFeature()
        )
        
        // We don't need to cover the whole flow, just be sure that the correct actions are called,
        // since the subsequent actions are is covered by other actions so we don't need exhaustivity this time.
        sut.exhaustivity = .off
        
        sut.dependencies.mainQueue = .immediate
        sut.dependencies.locationManager.delegate = Empty().eraseToAnyPublisher() // Dummy
        sut.dependencies.locationManager.lastLocationCoordinate = { nil } // Dummy
        sut.dependencies.locationManager.requestLocation = {} // Dummy
        
        // When
        await sut.send(.view(.onRetryButtonTapped))
        
        // Then
        await sut.receive(._internal(.loadVenuesUsingCurrentLocation))
    }
    
    func test_onPullToRefresh_shouldTryToLoadVenuesUsingCurrentLocation() async {
        // Given
        let sut = TestStore(
            initialState: initialState,
            reducer: NearMeFeature()
        )
        
        // We don't need to cover the whole flow, just be sure that the correct actions are called,
        // since the subsequent actions are is covered by other actions so we don't need exhaustivity this time.
        sut.exhaustivity = .off
        
        sut.dependencies.mainQueue = .immediate
        sut.dependencies.locationManager.delegate = Empty().eraseToAnyPublisher() // Dummy
        sut.dependencies.locationManager.lastLocationCoordinate = { nil } // Dummy
        sut.dependencies.locationManager.requestLocation = {} // Dummy
        
        // When
        await sut.send(.view(.onPullToRefresh))
        
        // Then
        await sut.receive(._internal(.loadVenuesUsingCurrentLocation))
    }
    
    func test_onRadiusButtonTapped_shouldPresentRadiusSelection() async {
        // Given
        initialState.route = nil // ensure there is not other scene being presented
        initialState.radiusSelectionState = nil // ensure that `radiusSelectionState` is clean to start
        
        let sut = TestStore(
            initialState: initialState,
            reducer: NearMeFeature()
        )
        
        let expectedRadiusSelectionState: RadiusSelectionFeature.State = .init(
            radiusValue: Double(initialState.searchRadius)
        )
        
        // When
        await sut.send(.view(.onRadiusButtonTapped)) {
            // Then
            $0.route = .radiusScene
            $0.radiusSelectionState = expectedRadiusSelectionState
        }
    }
    
    func test_dismissRadiusSheet_shouldTheRoute() async {
        // Given
        initialState.route = .radiusScene
        initialState.radiusSelectionState = .init(
            radiusValue: Double(initialState.searchRadius)
        )
        
        let sut = TestStore(
            initialState: initialState,
            reducer: NearMeFeature()
        )
        
        // When
        await sut.send(.view(.dismissRadiusSheet)) {
            // Then
            $0.route = nil
        }
    }
    
    // MARK: - Internal Flows or Actions Tests
    
    func test_handleLocationManagerEvent_whenPermissionRequestIsStillNeeded_itShouldPresentNoLoticationPermissionError() async {
        // Given
        let sut = TestStore(
            initialState: initialState,
            reducer: NearMeFeature()
        )
        
        // When
        await sut.send(._internal(.handleLocationManagerEvent(.didChangeAuthorization(.denied)))) {
            // Then
            $0.viewStage = .error(.noLocationPermission)
        }
    }
    
    func test_handleLocationManagerEvent_whenLocationManagerFails_itShouldPresentLocationManagerFailedError() async {
        // Given
        let sut = TestStore(
            initialState: initialState,
            reducer: NearMeFeature()
        )
        let dummyError: NSError = .init(
            domain: "NearMeFeatureTests",
            code: -1
        )
        
        // When
        await sut.send(._internal(.handleLocationManagerEvent(.didFailWithError(dummyError)))) {
            // Then
            $0.viewStage = .error(.locationManagerFailed)
        }
    }
    
    func test_handleLocationManagerEvent_whenLocationsAreUpdated_andCoordinateIsInvalid_itShouldNoValidLocationError() async {
        // Given
        let sut = TestStore(
            initialState: initialState,
            reducer: NearMeFeature()
        )
        
        // When
        await sut.send(._internal(.handleLocationManagerEvent(.didUpdateLocations([])))) {
            // Then
            $0.viewStage = .error(.noValidLocation)
        }
    }
    
    func test_handleLocationManagerEvent_whenLocationsAreUpdated_andCoordinateInvalid_itShouldLoadVenues() async {
        // Given
        let sut = TestStore(
            initialState: initialState,
            reducer: NearMeFeature()
        )
        
        // We don't need to cover the whole flow, just be sure that the correct actions are called,
        // since the subsequent actions are is covered by other actions so we don't need exhaustivity this time.
        sut.exhaustivity = .off
        
        let mockLocation: CLLocation = .init()
        let expectedSearchPlacesRequest: SearchPlacesRequest = .init(
            latitude: mockLocation.coordinate.latitude,
            longitude: mockLocation.coordinate.longitude,
            radius: initialState.searchRadius
        )
        
        sut.dependencies.placesService = PlacesServiceDummy()
        sut.dependencies.mainQueue = .immediate
        sut.dependencies.venueCardMapper = .dummy
        
        // When
        await sut.send(._internal(.handleLocationManagerEvent(.didUpdateLocations([mockLocation]))))
        
        // Then
        await sut.receive(._internal(.loadVenues(expectedSearchPlacesRequest)))
    }
    
    func test_loadVenues_whenServiceFails_itShouldPresentServiceError() async {
        // Given
        let sut = TestStore(
            initialState: initialState,
            reducer: NearMeFeature()
        )
        
        let dummyError: NSError = .init(
            domain: "NearMeFeatureTests",
            code: -1
        )
        placesServiceStub.searchPlacesResultToBeReturned = .failure(dummyError)
        sut.dependencies.placesService = placesServiceStub
        
        sut.dependencies.mainQueue = .immediate

        let dummyLocation: CLLocation = .init()
        let dummyRequest: SearchPlacesRequest = .init(
            latitude: dummyLocation.coordinate.latitude,
            longitude: dummyLocation.coordinate.longitude,
            radius: initialState.searchRadius
        )
        
        // When
        await sut.send(._internal(.loadVenues(dummyRequest)))
        
        // Then
        await sut.receive(._internal(.searchPlacesResult(.failure(dummyError)))) {
            $0.viewStage = .error(.serviceError)
        }
    }
    
    // MARK: - Child Flows Integration Tests
    
    func test_whenRadiusSheetIsPresented_thenApplyRadiusValueIsReceived_itShouldDismissTheSheetAndRealoadVenues() async {
        // Given
        initialState.route = .radiusScene
        initialState.radiusSelectionState = .init(
            radiusValue: Double(initialState.searchRadius)
        )
        
        let sut = TestStore(
            initialState: initialState,
            reducer: NearMeFeature()
        )
        
        // We don't need to cover the whole flow, just be sure that the correct actions are called,
        // since the subsequent actions are is covered by other actions so we don't need exhaustivity this time.
        sut.exhaustivity = .off
        
        sut.dependencies.mainQueue = .immediate
        sut.dependencies.locationManager.delegate = Empty().eraseToAnyPublisher() // Dummy
        sut.dependencies.locationManager.lastLocationCoordinate = { nil } // Dummy
        sut.dependencies.locationManager.requestLocation = {} // Dummy
        
        let expectedSearchRadius = 12345
        
        // When
        await sut.send(._internal(.radiusSelection(.delegate(.applyRadiusValue(expectedSearchRadius))))) {
            // Then
            $0.searchRadius = expectedSearchRadius
        }
        await sut.receive(.view(.dismissRadiusSheet)) {
            $0.route = nil
        }
        await sut.receive(._internal(.loadVenuesUsingCurrentLocation))
    }
}
