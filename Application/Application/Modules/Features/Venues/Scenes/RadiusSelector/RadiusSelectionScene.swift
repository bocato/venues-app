import ComposableArchitecture
import CoreLocation
import Dependencies
import SwiftUI
import TCABoundaries

struct RadiusSelectionScene: View {
    let store: StoreOf<RadiusSelectionFeature>
    var body: some View {
        WithViewStore(store.stateless) { viewStore in
            NavigationStack {
                VStack {
                    Text(L10n.RadiusSelection.Header.text)
                        .font(.headline)
                        .padding()
                    Spacer()
                    inputContainer
                    Spacer()
                    Button(L10n.RadiusSelection.Button.apply) {
                        viewStore.send(.view(.applyButtonTapped))
                    }
                    .buttonStyle(.bordered)
                }
                .navigationTitle(L10n.RadiusSelection.navigationTitle)
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
                Slider(
                    value: viewStore.binding(
                        get: \.radiusValue,
                        send: { .view(.radiusValueChanged($0)) }
                    ),
                    in: viewStore.sliderConfig.range
                )
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
                initialState: .init(radiusValue: 2_000),
                reducer: RadiusSelectionFeature()
            )
        )
    }
}
#endif
