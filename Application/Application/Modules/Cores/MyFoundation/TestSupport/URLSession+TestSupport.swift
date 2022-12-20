#if DEBUG
import Foundation

protocol MockURLResponder {
    static func respond(to request: URLRequest) throws -> Data
    static func response(for request: URLRequest) -> URLResponse
}

final class URLProtocolMock<Responder: MockURLResponder>: URLProtocol {
    override class func canInit(with _: URLRequest) -> Bool {
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
        guard let client = client else { return }

        let response = Responder.response(for: request)
        client.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)

        do {
            let data = try Responder.respond(to: request)
            client.urlProtocol(self, didLoad: data)
        } catch {
            client.urlProtocol(self, didFailWithError: error)
        }

        client.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {
        // Do nothing.
    }
}

enum MockURLResponderStub: MockURLResponder {
    static var resultToBeReturned: Result<Data, Error> = .success(.init())
    static func respond(to _: URLRequest) throws -> Data { try resultToBeReturned.get() }

    static var responseToBeReturned: URLResponse = .init()
    static func response(for _: URLRequest) -> URLResponse { responseToBeReturned }
}

extension URLSession {
    convenience init<T: MockURLResponder>(mockResponder _: T.Type) {
        let mockSessionConfiguration = URLSessionConfiguration.ephemeral
        mockSessionConfiguration.protocolClasses = [URLProtocolMock<T>.self]
        self.init(configuration: mockSessionConfiguration)
        URLProtocol.registerClass(URLProtocolMock<T>.self)
    }

    public static func mocking(
        response: URLResponse = .init(),
        result: Result<Data, Error> = .success(.init())
    ) -> URLSession {
        MockURLResponderStub.responseToBeReturned = response
        MockURLResponderStub.resultToBeReturned = result
        return .init(mockResponder: MockURLResponderStub.self)
    }
}

import XCTestDynamicOverlay

enum FailingMockURLResponder: MockURLResponder {
    static var file: StaticString = #file
    static var line: UInt = #line

    static func respond(to _: URLRequest) throws -> Data {
        XCTFail("MockURLResponder.respond(to:) should not be called on this test.", file: file, line: line)
        return .init()
    }

    static func response(for _: URLRequest) -> URLResponse {
        XCTFail("MockURLResponder.response(for:) should not be called on this test.", file: file, line: line)
        return .init()
    }
}

public extension URLSession {
    static func failing(
        file: StaticString = #file,
        line: UInt = #line
    ) -> URLSession {
        FailingMockURLResponder.file = file
        FailingMockURLResponder.line = line
        return .init(mockResponder: FailingMockURLResponder.self)
    }
}
#endif
