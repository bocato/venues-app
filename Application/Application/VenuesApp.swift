import SwiftUI

@main
struct VenuesApp: App {
    var body: some Scene {
        WindowGroup {
            AppRootScene(
                store: .init(
                    initialState: .init(),
                    reducer: AppRootFeature()
                )
            )
        }
    }
}
