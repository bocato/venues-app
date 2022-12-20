#if DEBUG
import Foundation

extension URL {
    static func dummy() -> Self {
        guard let dummyURL = URL(string: "www.dummyurl.com") else {
            preconditionFailure("This should allways succeed!")
        }
        return dummyURL
    }
}
#endif
