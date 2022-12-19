@testable import Application
import SnapshotTesting
import XCTest

final class VenueCardMapperTests: XCTestCase {
    // MARK: - Properties
    
    private let sut: VenueCardMapper = .live
    private let isRecordModeOn = false
    
    // MARK: - Tests
    
    func test_map_whenAllPropertiesArePresent() {
        // Given
        let entity: FoursquarePlace = .fixture()
        
        // When
        let model = sut.map(entity)
        
        // Then
        assertSnapshot(
            matching: model,
            as: .dump,
            record: isRecordModeOn
        )
    }
    
    func test_map_whenPhotosAreNotPresent() {
        // Given
        let entity: FoursquarePlace = .fixture(photos: [])
        
        // When
        let model = sut.map(entity)
        
        // Then
        assertSnapshot(
            matching: model,
            as: .dump,
            record: isRecordModeOn
        )
    }
    
    func test_map_whenCategoriesAreNotPresent() {
        // Given
        let entity: FoursquarePlace = .fixture(categories: [])
        
        // When
        let model = sut.map(entity)
        
        // Then
        assertSnapshot(
            matching: model,
            as: .dump,
            record: isRecordModeOn
        )
    }
    
    func test_map_whenNeighborhoodIsNotPresent() {
        // Given
        let entity: FoursquarePlace = .fixture(
            location: .fixture(
                neighborhood: nil
            )
        )
        
        // When
        let model = sut.map(entity)
        
        // Then
        assertSnapshot(
            matching: model,
            as: .dump,
            record: isRecordModeOn
        )
    }
}
