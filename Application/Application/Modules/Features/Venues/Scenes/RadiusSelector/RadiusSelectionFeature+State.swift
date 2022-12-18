import ComposableArchitecture
import CoreLocation
import Dependencies
import SwiftUI
import TCABoundaries

extension RadiusSelectionFeature {
    // MARK: - State
    struct State: Equatable {
        let sliderConfig: SliderConfig = .default
        var radiusValue: Int = SliderConfig.default.defaultValue
    }
}

extension RadiusSelectionFeature.State {
    struct SliderConfig: Equatable {
        let minValue: Int
        let maxValue: Int
        let defaultValue: Int
        
        static let `default`: Self = .init(
            minValue: 0,
            maxValue: 100_000,
            defaultValue: 2_000
        )
        
        var range: ClosedRange<Int> {
            minValue...maxValue
        }
    }
}
