@testable import Application
import XCTest

final class NetworkStatusManagerTests: XCTestCase {
    func test_init_shouldSetupTheInstanceProperly() {
        // Given
        let nwPathMonitorSpy: NWPathMonitorSpy = .init()
        // When
        _ = NetworkStatusManager(nwPathMonitor: nwPathMonitorSpy)
        // Then
        XCTAssertTrue(nwPathMonitorSpy.startCalled)
        XCTAssertEqual(nwPathMonitorSpy.queuePassed?.underlyingQueue, .global())
        XCTAssertTrue(nwPathMonitorSpy.setReachabilityObserverCalled)
        XCTAssertNotNil(nwPathMonitorSpy.setReachabilityObserverHandler)
    }

    func test_isNetworkReachable_shouldBeAlwaysUpdatedWithSetReachabilityObserverOutputs() {
        // Given
        let nwPathMonitorSpy: NWPathMonitorSpy = .init()
        let sut = NetworkStatusManager(nwPathMonitor: nwPathMonitorSpy)
        // When
        nwPathMonitorSpy.setReachabilityObserverHandler?(true)
        let firstValue = sut.isNetworkReachable()
        nwPathMonitorSpy.setReachabilityObserverHandler?(false)
        let secondValue = sut.isNetworkReachable()
        // Then
        XCTAssertTrue(firstValue)
        XCTAssertFalse(secondValue)
    }
}
