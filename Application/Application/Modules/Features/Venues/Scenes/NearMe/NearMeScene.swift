import ComposableArchitecture
import CoreLocation
import Dependencies
import SwiftUI
import TCABoundaries

//struct ContentView: View {
//    var body: some View {
//      NavigationView {
//        List {
//          ForEach(0 ..< 30) { item in
//            Text("Hello, world!")
//          }
//        }
//        .navigationTitle("Accessory View")
//        .safeAreaInset(edge: .top) {
//          AccessoryView()
//        }
//      }
//    }
//}
//
//struct AccessoryView: View {
//  var body: some View {
//    HStack {
//      Button("Button") { }
//      Button("Button") { }
//      Button("Button") { }
//      Spacer()
//    }
//    .padding()
//    .background(Color(uiColor: .systemGroupedBackground))
//    .buttonStyle(.bordered)
//    .controlSize(.mini)
//  }
//}

struct NearMeScene: View {
    let store: StoreOf<NearMeFeature>
    
    var body: some View {
        WithViewStore(store.stateless) { viewStore in
            NavigationStack {
                makeViewStages()
                    .navigationTitle(L10n.NearMe.navigationTitle)
                    .task { viewStore.send(.view(.onAppear)) }
                    .safeAreaInset(edge: .top) {
                        acessoryView
                    }
            }
        }
    }
    
    // MARK: - Components
    
    @ViewBuilder
    private var acessoryView: some View {
        HStack {
            Button(
                action: {
                    print("TODO: Call radius modal!")
                },
                label: {
                    HStack {
                        Text("Radius")
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
    
    // MARK: - View Stages
    
    @ViewBuilder
    private func makeViewStages() -> some View {
        WithViewStore(store, observe: \.viewStage) { viewStore in
            switch viewStore.state {
            case .loading:
                loadingView
            case .noLocation:
                noLocationView
            case let .venuesLoaded(cards):
                listView(cards)
            case .error:
                ErrorView(
                    onRetry: { viewStore.send(.view(.onErrorRetryButtonTapped)) }
                )
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
    
    private var noLocationView: some View {
        WithViewStore(store.stateless) { viewStore in
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
