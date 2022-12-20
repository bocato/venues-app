@testable import Application
import Foundation
import XCTest

final class HTTPRequestDispatcherTests: XCTestCase {
    // MARK: - Properties

    private let networkStatusManagerStub: NetworkStatusManagerStub = .init()
    private let defaultURLRequestBuilder: DefaultURLRequestBuilder = .init()
    private let urlRequestBuilderStub: URLRequestBuilderStub = .init()

    // MARK: - Tests
    
    func test_convenienceInit_shouldSetCorrectDefaults() async {
        // Given
        let sut: HTTPRequestDispatcher
        
        // When
        sut = .init()
        
        // Then
        let mirror: Mirror = .init(reflecting: sut)
        XCTAssertTrue(mirror.firstChild(of: URLSession.self) === URLSession.shared)
        XCTAssertTrue(mirror.firstChild(of: NetworkStatusManagerProtocol.self) === NetworkStatusManager.shared)
        XCTAssertTrue(mirror.firstChild(of: URLRequestBuilderProtocol.self) is DefaultURLRequestBuilder)
    }

    func test_asyncResponse_whenNetworkIsNotReachable_itShouldReturnUnreachableNetworkError() async {
        // Given
        networkStatusManagerStub.isNetworkReachableValue = false

        let sut: HTTPRequestDispatcher = .init(
            session: .failing(),
            networkStatusManager: networkStatusManagerStub,
            requestBuilder: defaultURLRequestBuilder
        )

        // When
        do {
            _ = try await sut.asyncResponse(for: DummyHTTPRequest())
            XCTFail("Expected error, not success.")
        } catch {
            // Then
            XCTAssertEqual(error as? HTTPRequestError, .unreachableNetwork)
        }
    }

    func test_asyncResponse_whenResponseIsNotHTTPURLResponse_itShouldReturnInvalidHTTPResponse() async {
        // Given
        let invalidResponse: URLResponse = .init()
        let sut: HTTPRequestDispatcher = .init(
            session: .mocking(
                response: invalidResponse
            ),
            networkStatusManager: networkStatusManagerStub,
            requestBuilder: defaultURLRequestBuilder
        )

        // When
        do {
            _ = try await sut.asyncResponse(for: DummyHTTPRequest())
            XCTFail("Expected error, not success.")
        } catch {
            // Then
            XCTAssertEqual(error as? HTTPRequestError, .invalidHTTPResponse)
        }
    }

    func test_asyncResponse_whenResponseIsNotOnSuccessRange_itShouldReturnDataTaskFailure() async {
        // Given
        let statusCode: Int = 400
        let failingResponse: HTTPURLResponse = .fixture(statusCode: statusCode)
        let dummyData: Data = .init()

        let sut: HTTPRequestDispatcher = .init(
            session: .mocking(
                response: failingResponse,
                result: .success(dummyData)
            ),
            networkStatusManager: networkStatusManagerStub,
            requestBuilder: defaultURLRequestBuilder
        )
        
        // When
        do {
            _ = try await sut.asyncResponse(for: DummyHTTPRequest())
            XCTFail("Expected error, not success.")
        } catch {
            // Then
            XCTAssertEqual(error as? HTTPRequestError, .yielding(data: dummyData, statusCode: statusCode))
        }
    }

    func test_asyncResponse_whenTheResponseIsValidAndOnSuccessRange_itShouldReturnResponseData() async throws {
        // Given
        let mockData: Data = .init()
        let statusCode: Int = 200
        let successResponse: HTTPURLResponse = .fixture(statusCode: statusCode)
        let sut: HTTPRequestDispatcher = .init(
            session: .mocking(
                response: successResponse,
                result: .success(mockData)
            ),
            networkStatusManager: networkStatusManagerStub,
            requestBuilder: defaultURLRequestBuilder
        )

        let expectedResponse: HTTPResponseData = .init(
            data: mockData,
            statusCode: statusCode
        )

        // When
        let response = try await sut.asyncResponse(for: DummyHTTPRequest())

        // Then
        XCTAssertEqual(response, expectedResponse)
    }

    func test_asyncResponse_whenNetworkConnectionErrorOccurs_itShouldReturnUnreachableNetworkError() async {
        // Given
        let networkConnectionError: URLError = .init(.networkConnectionLost)

        let sut: HTTPRequestDispatcher = .init(
            session: .mocking(
                result: .failure(networkConnectionError)
            ),
            networkStatusManager: networkStatusManagerStub,
            requestBuilder: defaultURLRequestBuilder
        )

        // When
        do {
            _ = try await sut.asyncResponse(for: DummyHTTPRequest())
            XCTFail("Expected error, not success.")
        } catch {
            // Then
            XCTAssertEqual(error as? HTTPRequestError, .unreachableNetwork)
        }
    }

    func test_asyncResponse_whenHTTPRequestErrorOccurs_itShouldReturnHTTPRequestError() async {
        // Given
        let requestError: HTTPRequestError = .unreachableNetwork
        let sut: HTTPRequestDispatcher = .init(
            session: .mocking(
                result: .failure(requestError)
            ),
            networkStatusManager: networkStatusManagerStub,
            requestBuilder: defaultURLRequestBuilder
        )
        
        // When
        do {
            _ = try await sut.asyncResponse(for: DummyHTTPRequest())
            XCTFail("Expected error, not success.")
        } catch {
            // Then
            XCTAssertTrue(error is HTTPRequestError)
        }
    }

    func test_asyncResponse_whenURLSessionErrorsOccur_itShouldReturnNetworkingError() async {
        // Given
        let urlError: URLError = .init(.badURL)
        let sut: HTTPRequestDispatcher = .init(
            session: .mocking(
                result: .failure(urlError)
            ),
            networkStatusManager: networkStatusManagerStub,
            requestBuilder: defaultURLRequestBuilder
        )

        let expectedError: HTTPRequestError = .networking(urlError)
        
        // When
        do {
            _ = try await sut.asyncResponse(for: DummyHTTPRequest())
            XCTFail("Expected error, not success.")
        } catch {
            // Then
            XCTAssertEqual(error as NSError, expectedError as NSError)
        }
    }

    func test_asyncResponse_whenRequestSerializationFails_itShouldReturnRequestSerializationError() async {
        // Given
        let serializationError: NSError = .init(
            domain: "JSONSerializationStub",
            code: -1,
            userInfo: nil
        )
        let urlRequestBuildingError: URLRequestBuildingError = .jsonSerialization(serializationError)
        urlRequestBuilderStub.buildResultToBeReturned = .failure(urlRequestBuildingError)

        let sut: HTTPRequestDispatcher = .init(
            session: .failing(),
            networkStatusManager: networkStatusManagerStub,
            requestBuilder: urlRequestBuilderStub
        )

        let expectedError: HTTPRequestError = .requestSerialization(urlRequestBuildingError)

        // When
        do {
            _ = try await sut.asyncResponse(for: DummyHTTPRequest())
            XCTFail("Expected error, not success.")
        } catch {
            // Then
            XCTAssertEqual(error as NSError, expectedError as NSError)
        }
    }
}

// MARK: - Test Doubles and Helpers

private struct JSONErrorMock: Error, Equatable, Codable {
    let message: String
}

private struct JSONValueMock: Equatable, Codable {
    let value: Int
}
