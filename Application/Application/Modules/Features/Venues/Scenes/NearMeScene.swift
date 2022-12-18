import ComposableArchitecture
import CoreLocation
import Dependencies
import SwiftUI
import TCABoundaries

struct NearMeScene: View {
    let store: StoreOf<NearMeFeature>
    
    var body: some View {
        WithViewStore(store.stateless) { viewStore in
            NavigationStack {
                makeViewStages()
                    .navigationTitle(L10n.NearMe.navigationTitle)
                    .onAppear { viewStore.send(.view(.onAppear)) }
            }
        }
    }
    
    // MARK: - View Stages
    
    @ViewBuilder
    private func makeViewStages() -> some View {
        WithViewStore(store, observe: \.viewStage) { viewStore in
            switch viewStore.state {
            case .loading:
                Text("Loading") // TODO: Add Loading View
            case .noLocation:
                InformationView(
                    data: .init(
                        title: L10n.NearMe.InfoView.NoLocation.text,
                        image: .errorTriangle
                    ),
                    actionButton: .init(
                        text: L10n.NearMe.InfoView.NoLocation.buttonTitle,
                        action: { viewStore.send(.view(.requestLocationPermissionsButtonTapped)) }
                    )
                )
            case let .venuesLoaded(cards):
                listView(cards)
            case .error:
                Text("Error") // TODO: Add Error View
            }
        }
    }
    
    @ViewBuilder
    private func listView(_ cards: [VenueCardModel]) -> some View {
        List {
            ForEach(cards) { card in
                VenueCard(model: card)
            }
        }
        .listRowSeparator(.visible)
        .listStyle(.inset)
    }
}

#if DEBUG
struct NearMeScene_Previews: PreviewProvider {
    static var previews: some View {
        NearMeScene(
            store: .init(
                initialState: .init(),
                reducer: NearMeFeature()
            )
        )
    }
}
#endif
