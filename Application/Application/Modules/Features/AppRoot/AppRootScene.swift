import SwiftUI

struct AppRootScene: View {
    var body: some View {
        TabView {
            nearMeTabView
            listTabView
            historyTabView
            meTabView
        }
    }
    
    @ViewBuilder
    private var nearMeTabView: some View {
        NearMeScene(
            store: .init(
                initialState: .init(),
                reducer: NearMeFeature()
            )
        )
        .tabItem {
            Image(systemName: "location.fill")
            Text("Near Me")
        }
    }
    
    @ViewBuilder private var listTabView: some View {
        Text("Unimplemented 😅")
            .tabItem {
                Image(systemName: "list.bullet")
                Text("List")
            }
    }

    @ViewBuilder private var historyTabView: some View {
        Text("Unimplemented 😅")
            .tabItem {
                Image(systemName: "list.clipboard.fill")
                Text("History")
            }
    }

    @ViewBuilder private var meTabView: some View {
        Text("Unimplemented 😅")
            .tabItem {
                Image(systemName: "person.crop.circle")
                Text("Me")
            }
    }
}

#if DEBUG
struct AppRootScene_Previews: PreviewProvider {
    static var previews: some View {
        AppRootScene()
    }
}
#endif
