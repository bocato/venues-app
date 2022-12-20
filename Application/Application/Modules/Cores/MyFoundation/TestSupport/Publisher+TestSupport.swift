#if DEBUG
import Combine
import XCTestDynamicOverlay

final class FailingPublisher<Output, Failure: Error>: Publisher {
    typealias Output = Output
    typealias Failure = Failure
    
    private let empty: Empty<Output, Failure> = .init(completeImmediately: true)
    
    func receive<S>(subscriber: S) where S : Subscriber, Failure == S.Failure, Output == S.Input {
        empty.receive(subscriber: subscriber)
        XCTFail("`FailingPublisher` always fails.")
    }
}

public extension Publisher {
    static var failing: AnyPublisher<Output, Failure> { FailingPublisher().eraseToAnyPublisher() }
}
#endif
