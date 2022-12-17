import Foundation

public final class HTTPRequestDispatcher: HTTPRequestDispatcherProtocol {
    // MARK: - Dependencies

    private let session: URLSession
    private let networkStatusManager: NetworkStatusManagerProtocol
    private let requestBuilder: URLRequestBuilderProtocol

    // MARK: - Initializer

    init(
        session: URLSession,
        networkStatusManager: NetworkStatusManagerProtocol,
        requestBuilder: URLRequestBuilderProtocol
    ) {
        self.session = session
        self.networkStatusManager = networkStatusManager
        self.requestBuilder = requestBuilder
    }

    public convenience init(session: URLSession = URLSession.shared) {
        self.init(
            session: session,
            networkStatusManager: NetworkStatusManager.shared,
            requestBuilder: DefaultURLRequestBuilder()
        )
    }

    // MARK: - Public API
    
    public func asyncResponse(for request: HTTPRequestProtocol) async throws -> HTTPResponseData {
        guard networkStatusManager.isNetworkReachable() else {
            throw HTTPRequestError.unreachableNetwork
        }
        do {
            let urlRequest = try requestBuilder.build(from: request)
            let (data, response) = try await session.data(for: urlRequest)
            return try handleServerResponse(
                data: data,
                urlResponse: response
            )
        } catch { throw handleRequestErrors(error) }
    }
    
    // MARK: - Private API
    
    private func handleServerResponse(data: Data, urlResponse: URLResponse) throws -> HTTPResponseData {
        guard
            let httpResponse = urlResponse as? HTTPURLResponse
        else { throw HTTPRequestError.invalidHTTPResponse }
        guard 200 ... 299 ~= httpResponse.statusCode else {
            throw HTTPRequestError.yielding(
                data: data,
                statusCode: httpResponse.statusCode
            )
        }
        
        return .init(
            data: data,
            statusCode: httpResponse.statusCode
        )
    }
    
    private func handleRequestErrors(_ rawError: Error) -> HTTPRequestError {
        switch rawError {
        case let requestBuildingError as URLRequestBuildingError:
            return HTTPRequestError.requestSerialization(requestBuildingError)
        case let urlError as URLError where urlError.code == .networkConnectionLost:
            return HTTPRequestError.unreachableNetwork
        case let requestError as HTTPRequestError:
            return requestError
        default:
            return HTTPRequestError.networking(rawError)
        }
    }
}
