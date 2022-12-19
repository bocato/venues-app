import Combine
import Foundation
import SwiftUI

// MARK: - Inner Types

public enum ImageLoadingState: Equatable {
    case empty
    case loading
    case loaded(Data)
}

final class ImageLoader: ObservableObject {
    
    // MARK: - Dependencies
    private let session: URLSession
    private let cache: URLCache
    private let runLoop: RunLoop

    // MARK: - Properties
    typealias State = ImageLoadingState
    @Published private(set) var state: State
    private var cancelBag: Set<AnyCancellable> = .init()

    // MARK: - Initialization
    
    init(
        session: URLSession = .shared,
        cache: URLCache = .shared,
        runLoop: RunLoop = .main,
        initialState: State = .empty
    ) {
        self.session = session
        self.cache = cache
        self.runLoop = runLoop
        state = initialState
    }

    // MARK: - Public API

    func loadData(for url: URL?) {
        guard let url else {
            state = .empty
            return
        }
        state = .loading
        loadData(for: url)
            .sink(
                receiveValue: { data in
                    if let data = data {
                        self.state = .loaded(data)
                    } else {
                        self.state = .empty
                    }
                }
            )
            .store(in: &cancelBag)
    }

    func cancel() {
        cancelBag.forEach { $0.cancel() }
        cancelBag.removeAll()
    }
    
    #if DEBUG
    func setState(_ state: State) {
        self.state = state
    }
    #endif

    // MARK: - Private Functions

    private func loadData(for url: URL) -> AnyPublisher<Data?, Never> {
        let request: URLRequest = .init(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 60.0)
        if let cachedData = cache.cachedResponse(for: request)?.data {
            return Just<Data?>(cachedData)
                .eraseToAnyPublisher()
        } else {
            return loadNetworkData(for: request)
        }
    }

    private func loadNetworkData(for request: URLRequest) -> AnyPublisher<Data?, Never> {
        session
            .dataTaskPublisher(for: request)
            .tryMap { data, response in
                guard
                    let statusCode = (response as? HTTPURLResponse)?.statusCode,
                    200 ... 299 ~= statusCode
                else {
                    throw NSError(domain: "ImageLoader", code: -999, userInfo: nil)
                }
                return data
            }
            .receive(on: runLoop)
            .replaceError(with: nil)
            .eraseToAnyPublisher()
    }
}
