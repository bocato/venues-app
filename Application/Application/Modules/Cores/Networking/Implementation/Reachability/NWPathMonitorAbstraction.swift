import Foundation
import Network

protocol NWPathMonitorProtocol {
    func start(queue: DispatchingQueue)
    func setReachabilityObserver(handler: @escaping (_ isReachable: Bool) -> Void)
}

extension NWPathMonitor: NWPathMonitorProtocol {
    func start(queue: DispatchingQueue) {
        start(queue: queue.underlyingQueue)
    }
    
    func setReachabilityObserver(handler: @escaping (_ isReachable: Bool) -> Void) {
        pathUpdateHandler = { nwPath in
            handler(nwPath.status == .satisfied)
        }
    }
}

#if DEBUG
final class NWPathMonitorSpy: NWPathMonitorProtocol {
    private(set) var startCalled = false
    private(set) var queuePassed: DispatchingQueue?
    func start(queue: DispatchingQueue) {
        startCalled = true
        queuePassed = queue
    }
    
    private(set) var setReachabilityObserverCalled = false
    private(set) var setReachabilityObserverHandler: ((_ isReachable: Bool) -> Void)?
    func setReachabilityObserver(handler: @escaping (Bool) -> Void) {
        setReachabilityObserverCalled = true
        setReachabilityObserverHandler = handler
    }
}
#endif
