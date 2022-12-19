import Combine
import Foundation
import SwiftUI

#if DEBUG
private enum ImageLoaderStateKey: EnvironmentKey {
    static let defaultValue: ImageLoadingState? = nil
}

extension EnvironmentValues {
  var imageLoaderStateStub: ImageLoadingState? {
    get { self[ImageLoaderStateKey.self] }
    set { self[ImageLoaderStateKey.self] = newValue }
  }
}

public extension View {
    func stubImageLoadingState(value: ImageLoadingState) -> some View {
        environment(\.imageLoaderStateStub, value)
    }
}
#endif
