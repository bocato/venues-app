// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen
// Custom template

import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name
internal enum L10n {

  internal enum EmptyContentView {
    internal enum Button {
      /// Refresh
      internal static var text: String {
        L10n.tr("Localizable", "emptyContentView.button.text")
      }
    }
  }

  internal enum ErrorView {
    /// Something is wrong, try again later.
    internal static var subtitle: String {
      L10n.tr("Localizable", "errorView.subtitle")
    }
    /// Ops!
    internal static var title: String {
      L10n.tr("Localizable", "errorView.title")
    }
    internal enum Button {
      /// Retry
      internal static var text: String {
        L10n.tr("Localizable", "errorView.button.text")
      }
    }
  }

  internal enum NearMe {
    /// Near Me
    internal static var navigationTitle: String {
      L10n.tr("Localizable", "nearMe.navigationTitle")
    }
    /// Near Me
    internal static var tabItemTitle: String {
      L10n.tr("Localizable", "nearMe.tabItemTitle")
    }
    internal enum AcessoryView {
      /// Options: 
      internal static var callout: String {
        L10n.tr("Localizable", "nearMe.acessoryView.callout")
      }
      internal enum Button {
        /// Radius
        internal static var radius: String {
          L10n.tr("Localizable", "nearMe.acessoryView.button.radius")
        }
      }
    }
    internal enum EmptyView {
      /// The list is empty, try again later.
      internal static var subtitle: String {
        L10n.tr("Localizable", "nearMe.emptyView.subtitle")
      }
      /// Oops!
      internal static var title: String {
        L10n.tr("Localizable", "nearMe.emptyView.title")
      }
    }
    internal enum InfoView {
      internal enum NoLocation {
        /// Request location permission
        internal static var buttonTitle: String {
          L10n.tr("Localizable", "nearMe.infoView.noLocation.buttonTitle")
        }
        /// To find the venues nearby, we need location permissions.
        internal static var text: String {
          L10n.tr("Localizable", "nearMe.infoView.noLocation.text")
        }
      }
    }
  }

  internal enum RadiusSelection {
    /// Select Radius
    internal static var navigationTitle: String {
      L10n.tr("Localizable", "radiusSelection.navigationTitle")
    }
    internal enum Button {
      /// Apply
      internal static var apply: String {
        L10n.tr("Localizable", "radiusSelection.button.apply")
      }
    }
    internal enum Header {
      /// Define below the range to be applied to the nearest venues search.
      internal static var text: String {
        L10n.tr("Localizable", "radiusSelection.header.text")
      }
    }
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    // swiftlint:disable:next nslocalizedstring_key
    let format = Bundle.main.localizedString(forKey: key, value: "", table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

