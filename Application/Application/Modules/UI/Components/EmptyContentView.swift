import SwiftUI

public struct EmptyContentView: View {
    // MARK: - Properties

    private let data: InformationView.Data
    private var actionButton: InformationView.ActionButton?

    // MARK: - Initialization

    public init(
        title: String,
        subtitle: String,
        onRefresh: (() -> Void)? = nil
    ) {
        data = .init(
            title: title,
            subtitle: subtitle,
            image: .init(
                sfSymbol: "icloud.slash"
            )
        )
        if let onRefreshClosure = onRefresh {
            actionButton = .init(
                text: L10n.EmptyContentView.Button.text,
                action: onRefreshClosure
            )
        }
    }

    // MARK: - UI

    public var body: some View {
        InformationView(
            data: data,
            actionButton: actionButton
        )
    }
}

 #if DEBUG
 struct EmptyContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            EmptyContentView(
                title: "Oh no!",
                subtitle: "It's empty! :("
            )
        }
    }
 }
 #endif
