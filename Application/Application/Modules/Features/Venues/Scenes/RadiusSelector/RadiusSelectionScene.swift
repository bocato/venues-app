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
                    inputsContainer
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
    
    private var inputsContainer: some View {
        WithViewStore(store) { viewStore in
            VStack(alignment: .center) {
                textInputView
                sliderContainer
            }
            .padding()
        }
    }
    
    private var textInputView: some View {
        WithViewStore(store) { viewStore in
            TextField(
                "",
                text: viewStore.binding(
                    get: { "\(Int($0.radiusValue))" },
                    send: { .view(.textFieldValueChanged($0)) }
                )
            )
            .font(.title2)
            .foregroundColor(.accentColor)
            .multilineTextAlignment(.center)
        }
    }
    
    private var sliderContainer: some View {
        WithViewStore(store) { viewStore in
            HStack(alignment: .center) {
                makeButton(
                    title: "-",
                    action: .decrementRadiusTapped
                )
                Slider(
                    value: viewStore.binding(
                        get: \.radiusValue,
                        send: { .view(.radiusSliderValueChanged($0)) }
                    ),
                    in: viewStore.sliderConfig.range
                )
                makeButton(
                    title: "+",
                    action: .incrementRadiusTapped
                )
            }
        }
    }
    
    private func makeButton(
        title: String,
        action: RadiusSelectionFeature.Action.ViewAction
    ) ->  some View {
        WithViewStore(store.stateless) { viewStore in
            Button(title) {
                viewStore.send(.view(action))
            }
            .buttonStyle(.bordered)
            .controlSize(.large)
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
