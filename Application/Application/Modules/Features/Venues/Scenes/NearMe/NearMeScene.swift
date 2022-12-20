import ComposableArchitecture
import CoreLocation
import Dependencies
import SwiftUI
import TCABoundaries
import SwiftUINavigation

struct NearMeScene: View {
    let store: StoreOf<NearMeFeature>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            NavigationStack {
                makeViewStages()
                    .navigationTitle(L10n.NearMe.navigationTitle)
                    .task { viewStore.send(.view(.onAppear)) }
                    .safeAreaInset(edge: .top) {
                        acessoryView
                    }
            }
            .sheet(
                unwrapping: .constant(viewStore.route),
                case: /NearMeFeature.State.Route.radiusScene,
                onDismiss: { viewStore.send(.view(.dismissRadiusSheet)) },
                content: { $binding in
                    IfLetStore(
                        store.scope(
                            state: \.radiusSelectionState,
                            action: /NearMeFeature.Action.InternalAction.radiusSelection
                        ),
                        then: RadiusSelectionScene.init(store:)
                    )
                }
            )
            .onDisappear { viewStore.send(.view(.onDisappear)) }
        }
    }
    
    // MARK: - Components
    
    @ViewBuilder
    private var acessoryView: some View {
        WithViewStore(store.stateless) { viewStore in
            HStack {
                Text(L10n.NearMe.AcessoryView.callout)
                    .font(.callout)
                    .bold()
                    .foregroundColor(.secondary)
                Button(
                    action: {
                        viewStore.send(.view(.onRadiusButtonTapped))
                    },
                    label: {
                        HStack {
                            Text(L10n.NearMe.AcessoryView.Button.radius)
                            Image(systemName: "map")
                        }
                    }
                )
                Spacer()
            }
            .padding()
            .background(Color(uiColor: .systemGroupedBackground))
            .buttonStyle(.bordered)
            .controlSize(.mini)
        }
    }
    
    // MARK: - View Stages
    
    @ViewBuilder
    private func makeViewStages() -> some View {
        WithViewStore(store, observe: \.viewStage) { viewStore in
            switch viewStore.state {
            case .loading:
                loadingView
            case let .venuesLoaded(cards):
                listView(cards)
            case .empty:
                EmptyContentView(
                    title: L10n.NearMe.EmptyView.title,
                    subtitle: L10n.NearMe.EmptyView.subtitle,
                    onRefresh: { viewStore.send(.view(.onRetryButtonTapped)) }
                )
            case let .error(failure):
                errorView(for: failure)
            }
        }
    }
    
    private var loadingView: some View {
        VStack {
            Spacer()
            ProgressView()
            Spacer()
        }
    }
    
    private func listView(_ cards: [VenueCardModel]) -> some View {
        WithViewStore(store.stateless) { viewStore in
            List {
                ForEach(cards) { card in
                    VenueCard(model: card)
                }
            }
            .listRowSeparator(.visible)
            .listStyle(.inset)
            .refreshable { viewStore.send(.view(.onPullToRefresh)) }
        }
    }
    
    @ViewBuilder
    private func errorView(for failure: NearMeFeature.State.ViewStage.Failure) -> some View {
        WithViewStore(store.stateless) { viewStore in
            switch failure {
            case .noLocationPermission:
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
            case .locationManagerFailed, .serviceError, .noValidLocation:
                ErrorView( // TODO: Better handling of the errors
                    onRetry: { viewStore.send(.view(.onRetryButtonTapped)) }
                )
            }
        }
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
