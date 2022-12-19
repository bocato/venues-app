@testable import Application
import SnapshotTesting
import SwiftUI
import UIKit
import XCTest

final class VenueCardTests: XCTestCase {
    // MARK: - Properties
    
    private let isRecordModeOn = false
    
    // MARK: - Tests
    
    func test_allPossibleLayouts() throws {
        // Given
        let allPossibleStates: [(name: String, model: VenueCardModel)] = [
            ("withAllFields", .mockWithAllFields),
            ("withRating", .mockWithRating),
            ("withDescription", .mockWithDescription),
            ("withKind", .mockWithKind),
            ("withNoOptionalFields", .mockWithNoOptionalFields),
        ]
        
        for state in allPossibleStates {
            // When
            let sut = try makeSUT(
                for: state.model
            )
            // Then
            assertSnapshot(
                matching: sut,
                as: .image,
                named: "test_layout_" + state.name,
                record: isRecordModeOn
            )
        }
    }
    
    // MARK: - Helpers
    
    private func makeSUT(
        for model: VenueCardModel,
        imageState: ImageLoadingState? = nil,
        file: StaticString = #file,
        line: UInt = #line
    ) throws -> some View {
        let imageData = try getImageDataMock(file: file, line: line)
        let imageStateStub = imageState ?? .loaded(imageData)
        return VenueCard(
            model: model
        ).frame(
            width: 250,
            height: 90
        )
        .stubImageLoadingState(value: imageStateStub)
    }
    
    private func getImageDataMock(
        file: StaticString = #file,
        line: UInt = #line
    ) throws -> Data {
        let image = try XCTUnwrap(
            UIImage(systemName: "ferry.fill"),
            file: file,
            line: line
        )
        let imageData = try XCTUnwrap(
            image.pngData(),
            file: file,
            line: line
        )
        return imageData
    }
}
