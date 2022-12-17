import Foundation

public protocol HTTPRequestDispatcherProtocol {
    func asyncResponse(for request: HTTPRequestProtocol) async throws -> HTTPResponseData
}
