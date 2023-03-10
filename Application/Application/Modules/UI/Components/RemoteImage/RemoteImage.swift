import Combine
import Foundation
import SwiftUI

public struct RemoteImage: View {
    // MARK: - Dependencies

    #if DEBUG
    @Environment(\.imageLoaderStateStub) var imageLoaderStateStub
    #endif
    @ObservedObject private var imageLoader: ImageLoader

    // MARK: - Properties

    private let url: URL?
    private let placeholder: AnyView
    private let cancelOnDisapear: Bool

    // MARK: - Initialization

    init(
        imageLoader: ImageLoader,
        url: URL?,
        placeholder: AnyView,
        cancelOnDisapear: Bool
    ) {
        self.imageLoader = imageLoader
        self.url = url
        self.placeholder = placeholder
        self.cancelOnDisapear = cancelOnDisapear
    }
    
    public init<Placeholder: View>(
        url: URL?,
        placeholder placeholderView: () -> Placeholder = { Image(systemName: "photo") },
        cancelOnDisapear: Bool = false
    ) {
        self.init(
            imageLoader: ImageLoader(),
            url: url,
            placeholder: .init(erasing: placeholderView()),
            cancelOnDisapear: cancelOnDisapear
        )
        commonInit()
    }
    
    private mutating func commonInit() {
        #if !DEBUG
        imageLoader.loadData(for: url)
        #endif
    }

    // MARK: - View

    public var body: some View {
        Group {
            switch imageLoader.state {
            case .empty:
                placeholder
            case .loading:
                ProgressView()
            case let .loaded(imageData):
                if let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                } else {
                    placeholder
                }
            }
        }
        #if DEBUG
        .onAppear {
            if let stubbedState = imageLoaderStateStub {
                imageLoader.setState(stubbedState)
            }
        }
        #endif
        .onDisappear {
            guard cancelOnDisapear else { return }
            imageLoader.cancel()
        }
        .scaledToFill()
        .clipped()
    }
}
