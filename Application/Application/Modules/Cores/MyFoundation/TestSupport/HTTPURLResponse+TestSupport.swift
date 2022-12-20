#if DEBUG
import Foundation

public extension HTTPURLResponse {
    static func fixture(
        url: URL = .dummy(),
        statusCode: Int = -1,
        httpVersion: String? = nil,
        headerFields: [String: String]? = nil
    ) -> HTTPURLResponse {
        guard let fixture = HTTPURLResponse(
            url: url,
            statusCode: statusCode,
            httpVersion: httpVersion,
            headerFields: headerFields
        ) else {
            preconditionFailure("This should allways succeed!")
        }
        return fixture
    }
}
#endif
