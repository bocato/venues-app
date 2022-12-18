import ComposableArchitecture
import CoreLocation
import Dependencies
import SwiftUI
import TCABoundaries

struct AppRootScene: View {
    let store: StoreOf<AppRootFeature>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            TabView(
                selection: .init(
                    get: { viewStore.selectedTab },
                    set: { viewStore.send(.view(.selectTab($0))) }
                )
            ) {
                nearMeTabView
                listTabView
                historyTabView
                meTabView
            }
            .onAppear { viewStore.send(.view(.onAppear)) }
        }
    }
    
    @ViewBuilder
    private var nearMeTabView: some View {
        NearMeScene(
            store: store.scope(
                state: \.nearMeTab,
                action: /AppRootFeature.Action.InternalAction.nearMeTab
            )
        )
        .tabItem {
            Image(systemName: "location.fill")
            Text(L10n.NearMe.tabItemTitle)
        }
        .tag(AppRootFeature.State.Tab.nearMe)
    }
    
    @ViewBuilder private var listTabView: some View {
        Text("Unimplemented 😅")
            .tabItem {
                Image(systemName: "list.bullet")
                Text("List")
            }
            .tag(AppRootFeature.State.Tab.list)
    }

    @ViewBuilder private var historyTabView: some View {
        Text("Unimplemented 😅")
            .tabItem {
                Image(systemName: "list.clipboard.fill")
                Text("History")
            }
            .tag(AppRootFeature.State.Tab.history)
    }

    @ViewBuilder private var meTabView: some View {
        Text("Unimplemented 😅")
            .tabItem {
                Image(systemName: "person.crop.circle")
                Text("Me")
            }
            .tag(AppRootFeature.State.Tab.me)
    }
}

#if DEBUG
struct AppRootScene_Previews: PreviewProvider {
    static var previews: some View {
        AppRootScene(
            store: .init(
                initialState: .init(),
                reducer: AppRootFeature()
            )
        )
    }
}
#endif
