// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(macOS)
  import AppKit
#elseif os(iOS)
  import UIKit
#elseif os(tvOS) || os(watchOS)
  import UIKit
#endif

// Deprecated typealiases
@available(*, deprecated, renamed: "ColorAsset.Color", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias AssetColorTypeAlias = ColorAsset.Color
@available(*, deprecated, renamed: "ImageAsset.Image", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias AssetImageTypeAlias = ImageAsset.Image

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Asset Catalogs

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
internal enum Asset {
  internal static let accentColor = ColorAsset(name: "AccentColor")
  internal static let borderContainerControl = ColorAsset(name: "border_container_control")
  internal static let borderViews = ColorAsset(name: "border_views")
  internal static let buttonBackground = ColorAsset(name: "button_background")
  internal static let darkGray = ColorAsset(name: "dark_gray")
  internal static let labelError = ColorAsset(name: "label_error")
  internal static let labelMenuItems = ColorAsset(name: "label_menu_items")
  internal static let labelText = ColorAsset(name: "label_text")
  internal static let lightGray = ColorAsset(name: "light_gray")
  internal static let menuBackground = ColorAsset(name: "menu_background")
  internal static let textField = ColorAsset(name: "textField")
  internal static let microphoneOrange = ImageAsset(name: "microphone_orange")
  internal static let microphoneRed = ImageAsset(name: "microphone_red")
  internal static let arrowLeft = ImageAsset(name: "arrow_left")
  internal static let arrowRight = ImageAsset(name: "arrow_right")
  internal static let backgroundToolbar = ImageAsset(name: "background_toolbar")
  internal static let barcodeIcon = ImageAsset(name: "barcode_icon")
  internal static let bottomStatusBar = ImageAsset(name: "bottom_status_bar")
  internal static let calendarIcon = ImageAsset(name: "calendar_icon")
  internal static let checkBlue = ImageAsset(name: "check_blue")
  internal static let checkedCheckbox = ImageAsset(name: "checked_checkbox")
  internal static let closeBlack = ImageAsset(name: "close_black")
  internal static let closeWhite = ImageAsset(name: "close_white")
  internal static let iconDelete = ImageAsset(name: "icon_delete")
  internal static let iconToolbar = ImageAsset(name: "icon_toolbar")
  internal static let settings = ImageAsset(name: "settings")
  internal static let uncheckedCheckbox = ImageAsset(name: "unchecked_checkbox")
  internal static let changeProfiles = ImageAsset(name: "change_profiles")
  internal static let closeSession = ImageAsset(name: "close_session")
  internal static let gridToolbar = ImageAsset(name: "grid_toolbar")
  internal static let homeToolbar = ImageAsset(name: "home_toolbar")
  internal static let menu = ImageAsset(name: "menu")
  internal static let notificationToolbar = ImageAsset(name: "notification_toolbar")
  internal static let profilePlaceholder = ImageAsset(name: "profile_placeholder")
  internal static let backgroundLogin = ImageAsset(name: "background_login")
  internal static let changeServer = ImageAsset(name: "change_server")
  internal static let expandArrow = ImageAsset(name: "expand_arrow")
  internal static let removeBlack = ImageAsset(name: "remove_black")
  internal static let appItem = ImageAsset(name: "app_item")
  internal static let indicatorItem = ImageAsset(name: "indicator_item")
  internal static let tabApp = ImageAsset(name: "tab_app")
  internal static let tabAppSelected = ImageAsset(name: "tab_app_selected")
  internal static let tabIndicator = ImageAsset(name: "tab_indicator")
  internal static let tabIndicatorSelected = ImageAsset(name: "tab_indicator_selected")
  internal static let tabOperation = ImageAsset(name: "tab_operation")
  internal static let tabOperationSelected = ImageAsset(name: "tab_operation_selected")
  internal static let tabSettings = ImageAsset(name: "tab_settings")
  internal static let tabSettingsSelected = ImageAsset(name: "tab_settings_selected")
  internal static let tabWorkflow = ImageAsset(name: "tab_workflow")
  internal static let tabWorkflowSelected = ImageAsset(name: "tab_workflow_selected")
  internal static let transactionItem = ImageAsset(name: "transaction_item")
  internal static let workflowItem = ImageAsset(name: "workflow_item")
  internal static let tileLocked = ImageAsset(name: "tile_locked")
  internal static let debugIcon = ImageAsset(name: "debug_icon")
  internal static let operationBar = ImageAsset(name: "operation_bar")
  internal static let operationClose = ImageAsset(name: "operation_close")
  internal static let operationRefresh = ImageAsset(name: "operation_refresh")
  internal static let operationStar = ImageAsset(name: "operation_star")
  internal static let operationStarGold = ImageAsset(name: "operation_star_gold")
  internal static let semaphoreGreen = ImageAsset(name: "semaphore_green")
  internal static let thermalCenter = ImageAsset(name: "thermal_center")
}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

// MARK: - Implementation Details

internal final class ColorAsset {
  internal fileprivate(set) var name: String

  #if os(macOS)
  internal typealias Color = NSColor
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  internal typealias Color = UIColor
  #endif

  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  internal private(set) lazy var color: Color = Color(asset: self)

  #if os(iOS) || os(tvOS)
  @available(iOS 11.0, tvOS 11.0, *)
  internal func color(compatibleWith traitCollection: UITraitCollection) -> Color {
    let bundle = BundleToken.bundle
    guard let color = Color(named: name, in: bundle, compatibleWith: traitCollection) else {
      fatalError("Unable to load color asset named \(name).")
    }
    return color
  }
  #endif

  fileprivate init(name: String) {
    self.name = name
  }
}

internal extension ColorAsset.Color {
  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  convenience init!(asset: ColorAsset) {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSColor.Name(asset.name), bundle: bundle)
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

internal struct ImageAsset {
  internal fileprivate(set) var name: String

  #if os(macOS)
  internal typealias Image = NSImage
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  internal typealias Image = UIImage
  #endif

  @available(iOS 8.0, tvOS 9.0, watchOS 2.0, macOS 10.7, *)
  internal var image: Image {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    let image = Image(named: name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    let name = NSImage.Name(self.name)
    let image = (bundle == .main) ? NSImage(named: name) : bundle.image(forResource: name)
    #elseif os(watchOS)
    let image = Image(named: name)
    #endif
    guard let result = image else {
      fatalError("Unable to load image asset named \(name).")
    }
    return result
  }

  #if os(iOS) || os(tvOS)
  @available(iOS 8.0, tvOS 9.0, *)
  internal func image(compatibleWith traitCollection: UITraitCollection) -> Image {
    let bundle = BundleToken.bundle
    guard let result = Image(named: name, in: bundle, compatibleWith: traitCollection) else {
      fatalError("Unable to load image asset named \(name).")
    }
    return result
  }
  #endif
}

internal extension ImageAsset.Image {
  @available(iOS 8.0, tvOS 9.0, watchOS 2.0, *)
  @available(macOS, deprecated,
    message: "This initializer is unsafe on macOS, please use the ImageAsset.image property")
  convenience init!(asset: ImageAsset) {
    #if os(iOS) || os(tvOS)
    let bundle = BundleToken.bundle
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSImage.Name(asset.name))
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
