import Foundation
import Network

protocol NetworkStatusManagerProtocol {
    func isNetworkReachable() -> Bool
}

final class NetworkStatusManager: NetworkStatusManagerProtocol {
    // MARK: - Dependencies

    private let nwPathMonitor: NWPathMonitorProtocol
    private let monitorQueue: DispatchingQueue

    // MARK: - Properties

    private var isConnectionActive: Bool = false

    // MARK: - Singleton

    static let shared = NetworkStatusManager()

    // MARK: - Initialization

    init(
        nwPathMonitor: NWPathMonitorProtocol = NWPathMonitor(),
        monitorQueue: DispatchingQueue = AsyncQueue.global
    ) {
        self.nwPathMonitor = nwPathMonitor
        self.monitorQueue = monitorQueue
        setup()
    }

    // MARK: - Private API

    private func setup() {
        nwPathMonitor.start(queue: monitorQueue)
        nwPathMonitor.setReachabilityObserver { [weak self] isReachable in
            self?.isConnectionActive = isReachable
        }
    }

    // MARK: - Public API

    func isNetworkReachable() -> Bool {
        isConnectionActive
    }
}

#if DEBUG
final class NetworkStatusManagerStub: NetworkStatusManagerProtocol {
    var isNetworkReachableValue: Bool = true
    func isNetworkReachable() -> Bool {
        isNetworkReachableValue
    }
}
#endif
