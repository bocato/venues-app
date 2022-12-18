import ComposableArchitecture
import CoreLocation
import Dependencies
import SwiftUI
import TCABoundaries

struct RadiusSelectionScene: View {
    let store: StoreOf<RadiusSelectionFeature>
    var body: some View {
        WithViewStore(store) { viewStore in
            NavigationStack {
                VStack {
                    Text("Define below the range to be applied to the nearest venues search.")
                        .font(.headline)
                        .padding()
                    Spacer()
                    inputContainer
                    Spacer()
                    Button(action: {
                        // add code to apply the value in the text field here
                    }) {
                        Text("Apply")
                    }
                    .buttonStyle(.bordered)
                }
                .navigationTitle("Radius")
            }
        }
    }
    
    private var inputContainer: some View {
        WithViewStore(store) { viewStore in
            HStack {
                Button("-") {
                    viewStore.send(.view(.decrementRadiusTapped))
                }
                .buttonStyle(.bordered)
                .controlSize(.mini)
//                Slider(
//                    value: viewStore.binding(
//                        get: \.radiusValue,
//                        send: { .view(.radiusValueChanged($0)) }
//                    ),
//                    in: viewStore.sliderConfig.range
//                )
                Button("+") {
                    viewStore.send(.view(.incrementRadiusTapped))
                }
                .buttonStyle(.bordered)
                .controlSize(.mini)
            }
            .padding()
        }
    }
}

#if DEBUG
struct RadiusSelectionScene_Previews: PreviewProvider {
    static var previews: some View {
        RadiusSelectionScene(
            store: .init(
                initialState: .init(),
                reducer: RadiusSelectionFeature()
            )
        )
    }
}
#endif
