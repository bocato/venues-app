import Foundation

/// Describes something that can dispatch a work to be done.
public protocol DispatchingQueue {
    /// The internal underlying system queue that will execute the work in our abstraction
    var underlyingQueue: DispatchQueue { get }
    /// Dispatches the work to be done.
    /// - Parameter work: the closure with the unity of work to be executed
    func dispatch(_ work: @escaping () -> Void)
    /// Dispatches the work to be done after a specified interval
    /// - Parameters:
    ///   - time: <#time description#>
    ///   - work: the work closure to be executed
    func dispatch(after time: DispatchTimeInterval, _ work: @escaping () -> Void)
}

/// Describes a queue that will run asynchronously.
public struct AsyncQueue: DispatchingQueue {
    public let underlyingQueue: DispatchQueue
    init(queue: DispatchQueue) {
        self.underlyingQueue = queue
    }
    
    public func dispatch(_ work: @escaping () -> Void) {
        underlyingQueue.async(execute: work)
    }
    
    public func dispatch(after time: DispatchTimeInterval, _ work: @escaping () -> Void) {
        underlyingQueue.asyncAfter(deadline: DispatchTime.now() + time, execute: work)
    }
}

public extension AsyncQueue {
    /// Same as DispatchQueue.main
    static let main: AsyncQueue = .init(queue: .main)
    /// Same as DispatchQueue.global()
    static let global: AsyncQueue = .init(queue: .global())
    /// Same as DispatchQueue.background
    static let background: AsyncQueue = .init(queue: .global(qos: .background))
}

/// Describes a queue that will run synchronously.
public struct SyncQueue: DispatchingQueue {
    public let underlyingQueue: DispatchQueue
    init(queue: DispatchQueue) {
        self.underlyingQueue = queue
    }
    
    public func dispatch(_ work: @escaping () -> Void) {
        underlyingQueue.sync(execute: work)
    }
    
    public func dispatch(after time: DispatchTimeInterval, _ work: @escaping () -> Void) {
        fatalError("You are trying to perform asyc operations on a synchronous queue. Consider using an AsyncQueue.")
    }
}

public extension SyncQueue {
    /// Same as DispatchQueue.main
    static let main: SyncQueue = .init(queue: .main)
    /// Same as DispatchQueue.global()
    static let global: SyncQueue = .init(queue: .global())
    /// Same as DispatchQueue.background
    static let background: SyncQueue = .init(queue: .global(qos: .background))
}

#if DEBUG
import XCTestDynamicOverlay

public final class FailingQueue: DispatchingQueue {
    public var underlyingQueue: DispatchQueue {
        XCTFail("FailingQueue always fails!")
        return .global()
    }
    
    public func dispatch(_ work: @escaping () -> Void) {
        XCTFail("FailingQueue always fails!")
    }
    
    public func dispatch(after time: DispatchTimeInterval, _ work: @escaping () -> Void) {
        XCTFail("FailingQueue always fails!")
    }
}

public extension SyncQueue {
    /// A sync queue that always fails.
    static let failing: FailingQueue = .init()
}

public extension AsyncQueue {
    /// An async queue that always fails.
    static let failing: FailingQueue = .init()
}
#endif
