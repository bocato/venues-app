import SwiftUI

extension InformationView {
    public struct Data {
        public let title: String
        public let subtitle: String?
        public let image: ImageResource

        public init(
            title: String,
            subtitle: String? = nil,
            image: ImageResource
        ) {
            self.title = title
            self.subtitle = subtitle
            self.image = image
        }

        public struct ImageResource {
            /// This is related to `systemName`, please check SFSymbols
            public let sfSymbol: String
            public let color: Color?

            public init(
                sfSymbol: String,
                color: Color = .secondary
            ) {
                self.sfSymbol = sfSymbol
                self.color = color
            }
        }
    }

    public struct ActionButton {
        public let text: String
        public let action: () -> Void

        public init(
            text: String,
            action: @escaping () -> Void
        ) {
            self.text = text
            self.action = action
        }
    }
}

public struct InformationView: View {
    // MARK: - Properties

    private let data: Data
    private let actionButton: ActionButton?

    // MARK: - Initialization

    public init(
        data: Data,
        actionButton: ActionButton? = nil
    ) {
        self.data = data
        self.actionButton = actionButton
    }

    // MARK: - UI

    public var body: some View {
        VStack(spacing: DS.Spacing.base) {
            Image(systemName: data.image.sfSymbol)
                .resizable()
                .frame(width: DS.LayoutSize.large.width, height: DS.LayoutSize.large.height)
                .foregroundColor(data.image.color)

            VStack(spacing: DS.Spacing.xSmall) {
                Text(data.title)
                    .foregroundColor(.primary)
                    .bold()
                if let subtitle = data.subtitle {
                    Text(subtitle)
                        .foregroundColor(.primary)
                }
            }
            .multilineTextAlignment(.center)

            if let actionButton = actionButton {
                Button(
                    actionButton.text,
                    action: actionButton.action
                )
            }
        }
        .alignmentGuide(VerticalAlignment.center) { $0[VerticalAlignment.center] * 1.1 }
        .padding(DS.Spacing.medium)
        .frame(
            minWidth: .zero,
            maxWidth: .infinity,
            minHeight: .zero,
            maxHeight: .infinity
        )
    }
}
