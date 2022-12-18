import SwiftUI

extension ErrorView {
    public typealias Data = InformationView.Data
    public typealias ActionButton = InformationView.ActionButton
}

extension ErrorView.Data {
    public static let defaultErrorLayout: Self = .init(
        title: L10n.ErrorView.title,
        subtitle: L10n.ErrorView.subtitle,
        image: .errorTriangle
    )
}

extension InformationView.Data.ImageResource {
    static let errorTriangle: Self = .init(
        sfSymbol: "exclamationmark.triangle.fill",
        color: .red
    )
}

public struct ErrorView: View {
    // MARK: - Properties

    private let data: Data
    private let retryButton: ActionButton

    // MARK: - Initialization

    public init(
        data: Data = .defaultErrorLayout,
        onRetry: @escaping () -> Void
    ) {
        self.data = data
        retryButton = .init(
            text: L10n.ErrorView.Button.text,
            action: onRetry
        )
    }

    // MARK: - UI

    public var body: some View {
        InformationView(
            data: data,
            actionButton: retryButton
        )
    }
}
