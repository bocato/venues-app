@testable import Application
import Foundation
import SnapshotTesting
import XCTest

final class DefaultURLRequestBuilderTests: XCTestCase {
    // MARK: - Properties
    
    private let isRecordModeOn = false
    
    // MARK: - Tests

    func test_build_body_whenParametersAreInvalid_shouldThrowError() throws {
        // Given
        let errorMock: NSError = .init(
            domain: "DefaultRequestBuilderTests",
            code: -1,
            userInfo: nil
        )
        JSONSerializationStub.dataWithJSONObjectResultToBeReturned = .failure(errorMock)

        let sut: DefaultURLRequestBuilder = .init(
            jsonSerializer: JSONSerializationStub.self
        )

        let request: AnyHTTPRequest = .init(
            baseURL: .dummy(),
            method: .get,
            parameters: .body(["key_1": "value_1"])
        )

        // When / Then
        XCTAssertThrowsError(try sut.build(from: request))
    }

    func test_build_body_shouldEncodeParameters() throws {
        // Given
        let sut: DefaultURLRequestBuilder = .init()

        let request: AnyHTTPRequest = .init(
            baseURL: .dummy(),
            method: .get,
            parameters: .body(["key_1": "value_1", "key_2": "value_2"])
        )

        // When
        let urlRequest = try XCTUnwrap(try? sut.build(from: request))

        // Then
        assertSnapshot(
            matching: urlRequest,
            as: .dump,
            record: isRecordModeOn
        )
    }

    func test_build_urlQuery_shouldSetQueryParamsCorrectly() throws {
        // Given
        let sut: DefaultURLRequestBuilder = .init(
            jsonSerializer: FailingJSONSerialization.self
        )

        let request: AnyHTTPRequest = .init(
            baseURL: .dummy(),
            method: .get,
            parameters: .urlQuery(["key_1": "value_1"])
        )

        // When
        let urlRequest = try XCTUnwrap(try? sut.build(from: request))

        // Then
        assertSnapshot(
            matching: urlRequest,
            as: .dump,
            record: isRecordModeOn
        )
    }

    func test_build_bodyData_shouldSetBodyData() throws {
        // Given
        let sut: DefaultURLRequestBuilder = .init(
            jsonSerializer: FailingJSONSerialization.self
        )

        let bodyData = try XCTUnwrap("Some value".data(using: .utf8))
        let request: AnyHTTPRequest = .init(
            baseURL: .dummy(),
            method: .get,
            parameters: .bodyData(bodyData)
        )

        // When
        let urlRequest = try XCTUnwrap(try? sut.build(from: request))

        // Then
        assertSnapshot(
            matching: urlRequest,
            as: .dump,
            record: isRecordModeOn
        )
    }

    func test_build_requestPlain_shouldAppendPathAndHeaders() throws {
        // Given
        let sut: DefaultURLRequestBuilder = .init(
            jsonSerializer: FailingJSONSerialization.self
        )

        let request: AnyHTTPRequest = .init(
            baseURL: .dummy(),
            path: "path",
            method: .get,
            parameters: .requestPlain,
            headers: ["key": "value"]
        )

        // When
        let urlRequest = try XCTUnwrap(try? sut.build(from: request))

        // Then
        assertSnapshot(
            matching: urlRequest,
            as: .dump,
            record: isRecordModeOn
        )
    }
}
