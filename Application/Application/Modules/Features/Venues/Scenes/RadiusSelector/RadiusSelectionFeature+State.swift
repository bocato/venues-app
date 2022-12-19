import ComposableArchitecture
import CoreLocation
import Dependencies
import SwiftUI
import TCABoundaries

extension RadiusSelectionFeature {
    // MARK: - State
    struct State: Equatable {
        let sliderConfig: SliderConfig = .default
        var radiusValue: Double
    }
}

extension RadiusSelectionFeature.State {
    struct SliderConfig: Equatable {
        let minValue: Double
        let maxValue: Double
        
        static let `default`: Self = .init(
            minValue: 0,
            maxValue: 100_000
        )
        
        var range: ClosedRange<Double> {
            minValue...maxValue
        }
    }
}
