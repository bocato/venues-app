#if DEBUG
import Foundation
import XCTestDynamicOverlay

public final class FailingJSONSerialization: JSONSerialization {
    public override init() {
        super.init()
    }
    
    public override class func data(withJSONObject _: Any, options _: JSONSerialization.WritingOptions = []) throws -> Data {
        XCTFail("JSONSerialization.data(withJSONObject:options:) should not be called.")
        return .init()
    }
}

final class JSONSerializationStub: JSONSerialization {
    public override init() {
        super.init()
    }
    
    public static var dataWithJSONObjectResultToBeReturned: Result<Data, Error> = .success(.init())
    public override class func data(withJSONObject _: Any, options _: JSONSerialization.WritingOptions = []) throws -> Data {
        try dataWithJSONObjectResultToBeReturned.get()
    }
}
#endif
