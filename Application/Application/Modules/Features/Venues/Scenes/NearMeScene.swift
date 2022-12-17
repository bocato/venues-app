import SwiftUI
import ComposableArchitecture


struct NearMeScene: View {
    var body: some View {
        NavigationStack {
            List {
                VenueCard(model: .mock)
            }
            .listRowSeparator(.visible)
            .listStyle(.inset)
            .navigationTitle("Near me")
        }
    }
}

struct NearMeScene_Previews: PreviewProvider {
    static var previews: some View {
        NearMeScene()
    }
}
