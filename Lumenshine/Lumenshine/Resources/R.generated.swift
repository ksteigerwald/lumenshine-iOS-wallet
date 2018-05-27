//
// This is a generated file, do not edit!
// Generated by R.swift, see https://github.com/mac-cain13/R.swift
//

import Foundation
import Rswift
import UIKit

/// This `R` struct is generated and contains references to static resources.
struct R: Rswift.Validatable {
  fileprivate static let applicationLocale = hostingBundle.preferredLocalizations.first.flatMap(Locale.init) ?? Locale.current
  fileprivate static let hostingBundle = Bundle(for: R.Class.self)
  
  static func validate() throws {
    try intern.validate()
  }
  
  /// This `R.color` struct is generated, and contains static references to 0 colors.
  struct color {
    fileprivate init() {}
  }
  
  /// This `R.file` struct is generated, and contains static references to 1 files.
  struct file {
    /// Resource file `MaterialIcons.bundle`.
    static let materialIconsBundle = Rswift.FileResource(bundle: R.hostingBundle, name: "MaterialIcons", pathExtension: "bundle")
    
    /// `bundle.url(forResource: "MaterialIcons", withExtension: "bundle")`
    static func materialIconsBundle(_: Void = ()) -> Foundation.URL? {
      let fileResource = R.file.materialIconsBundle
      return fileResource.bundle.url(forResource: fileResource)
    }
    
    fileprivate init() {}
  }
  
  /// This `R.font` struct is generated, and contains static references to 0 fonts.
  struct font {
    fileprivate init() {}
  }
  
  /// This `R.image` struct is generated, and contains static references to 3 images.
  struct image {
    /// Image `FaceIcon`.
    static let faceIcon = Rswift.ImageResource(bundle: R.hostingBundle, name: "FaceIcon")
    /// Image `MenuColor`.
    static let menuColor = Rswift.ImageResource(bundle: R.hostingBundle, name: "MenuColor")
    /// Image `Touch-icon-lg`.
    static let touchIconLg = Rswift.ImageResource(bundle: R.hostingBundle, name: "Touch-icon-lg")
    
    /// `UIImage(named: "FaceIcon", bundle: ..., traitCollection: ...)`
    static func faceIcon(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.faceIcon, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "MenuColor", bundle: ..., traitCollection: ...)`
    static func menuColor(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.menuColor, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "Touch-icon-lg", bundle: ..., traitCollection: ...)`
    static func touchIconLg(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.touchIconLg, compatibleWith: traitCollection)
    }
    
    fileprivate init() {}
  }
  
  /// This `R.nib` struct is generated, and contains static references to 0 nibs.
  struct nib {
    fileprivate init() {}
  }
  
  /// This `R.reuseIdentifier` struct is generated, and contains static references to 0 reuse identifiers.
  struct reuseIdentifier {
    fileprivate init() {}
  }
  
  /// This `R.segue` struct is generated, and contains static references to 0 view controllers.
  struct segue {
    fileprivate init() {}
  }
  
  /// This `R.storyboard` struct is generated, and contains static references to 1 storyboards.
  struct storyboard {
    /// Storyboard `LaunchScreen`.
    static let launchScreen = _R.storyboard.launchScreen()
    
    /// `UIStoryboard(name: "LaunchScreen", bundle: ...)`
    static func launchScreen(_: Void = ()) -> UIKit.UIStoryboard {
      return UIKit.UIStoryboard(resource: R.storyboard.launchScreen)
    }
    
    fileprivate init() {}
  }
  
  /// This `R.string` struct is generated, and contains static references to 2 localization tables.
  struct string {
    /// This `R.string.common` struct is generated, and contains static references to 4 localization keys.
    struct common {
      /// en translation: Cancel
      /// 
      /// Locales: en
      static let cancel = Rswift.StringResource(key: "cancel", tableName: "Common", bundle: R.hostingBundle, locales: ["en"], comment: nil)
      /// en translation: No
      /// 
      /// Locales: en
      static let no = Rswift.StringResource(key: "no", tableName: "Common", bundle: R.hostingBundle, locales: ["en"], comment: nil)
      /// en translation: Ok
      /// 
      /// Locales: en
      static let ok = Rswift.StringResource(key: "ok", tableName: "Common", bundle: R.hostingBundle, locales: ["en"], comment: nil)
      /// en translation: Yes
      /// 
      /// Locales: en
      static let yes = Rswift.StringResource(key: "yes", tableName: "Common", bundle: R.hostingBundle, locales: ["en"], comment: nil)
      
      /// en translation: Cancel
      /// 
      /// Locales: en
      static func cancel(_: Void = ()) -> String {
        return NSLocalizedString("cancel", tableName: "Common", bundle: R.hostingBundle, comment: "")
      }
      
      /// en translation: No
      /// 
      /// Locales: en
      static func no(_: Void = ()) -> String {
        return NSLocalizedString("no", tableName: "Common", bundle: R.hostingBundle, comment: "")
      }
      
      /// en translation: Ok
      /// 
      /// Locales: en
      static func ok(_: Void = ()) -> String {
        return NSLocalizedString("ok", tableName: "Common", bundle: R.hostingBundle, comment: "")
      }
      
      /// en translation: Yes
      /// 
      /// Locales: en
      static func yes(_: Void = ()) -> String {
        return NSLocalizedString("yes", tableName: "Common", bundle: R.hostingBundle, comment: "")
      }
      
      fileprivate init() {}
    }
    
    /// This `R.string.localizable` struct is generated, and contains static references to 59 localization keys.
    struct localizable {
      /// en translation: %1$d days ago
      /// 
      /// Locales: en
      static let xMoment_days = Rswift.StringResource(key: "x-moment_days", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en"], comment: nil)
      /// en translation: %1$d hours ago
      /// 
      /// Locales: en
      static let xMoment_hours = Rswift.StringResource(key: "x-moment_hours", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en"], comment: nil)
      /// en translation: %1$d minutes ago
      /// 
      /// Locales: en
      static let xMoment_minutes = Rswift.StringResource(key: "x-moment_minutes", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en"], comment: nil)
      /// en translation: %1$d months ago
      /// 
      /// Locales: en
      static let xMoment_months = Rswift.StringResource(key: "x-moment_months", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en"], comment: nil)
      /// en translation: %1$d seconds ago
      /// 
      /// Locales: en
      static let xMoment_seconds = Rswift.StringResource(key: "x-moment_seconds", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en"], comment: nil)
      /// en translation: %1$d weeks ago
      /// 
      /// Locales: en
      static let xMoment_weeks = Rswift.StringResource(key: "x-moment_weeks", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en"], comment: nil)
      /// en translation: %1$d years ago
      /// 
      /// Locales: en
      static let xMoment_years = Rswift.StringResource(key: "x-moment_years", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en"], comment: nil)
      /// en translation: Account specific data
      /// 
      /// Locales: en
      static let account_data_title = Rswift.StringResource(key: "account_data_title", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en"], comment: nil)
      /// en translation: Already confirmed
      /// 
      /// Locales: en
      static let email_already_confirmed = Rswift.StringResource(key: "email_already_confirmed", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en"], comment: nil)
      /// en translation: Anonymous
      /// 
      /// Locales: en
      static let unknown = Rswift.StringResource(key: "unknown", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en"], comment: nil)
      /// en translation: Autogenerated 2FA code with secret: %@
      /// 
      /// Locales: en
      static let lbl_tfa_secret_hint = Rswift.StringResource(key: "lbl_tfa_secret_hint", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en"], comment: nil)
      /// en translation: Back
      /// 
      /// Locales: en
      static let back = Rswift.StringResource(key: "back", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en"], comment: nil)
      /// en translation: Cancel
      /// 
      /// Locales: en
      static let cancel = Rswift.StringResource(key: "cancel", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en"], comment: nil)
      /// en translation: Close
      /// 
      /// Locales: en
      static let close = Rswift.StringResource(key: "close", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en"], comment: nil)
      /// en translation: Delete
      /// 
      /// Locales: en
      static let delete = Rswift.StringResource(key: "delete", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en"], comment: nil)
      /// en translation: Delete
      /// 
      /// Locales: en
      static let lbl_delete = Rswift.StringResource(key: "lbl_delete", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en"], comment: nil)
      /// en translation: Deposit money
      /// 
      /// Locales: en
      static let deposit = Rswift.StringResource(key: "deposit", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en"], comment: nil)
      /// en translation: Error
      /// 
      /// Locales: en
      static let error = Rswift.StringResource(key: "error", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en"], comment: nil)
      /// en translation: Get Started
      /// 
      /// Locales: en
      static let get_started_button = Rswift.StringResource(key: "get_started_button", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en"], comment: nil)
      /// en translation: I have written it down
      /// 
      /// Locales: en
      static let lbl_mnemonic_button_title = Rswift.StringResource(key: "lbl_mnemonic_button_title", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en"], comment: nil)
      /// en translation: Invalid request
      /// 
      /// Locales: en
      static let invalid_request = Rswift.StringResource(key: "invalid_request", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en"], comment: nil)
      /// en translation: Let's go
      /// 
      /// Locales: en
      static let go = Rswift.StringResource(key: "go", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en"], comment: nil)
      /// en translation: Log Out
      /// 
      /// Locales: en
      static let logout = Rswift.StringResource(key: "logout", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en"], comment: nil)
      /// en translation: Login
      /// 
      /// Locales: en
      static let login = Rswift.StringResource(key: "login", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en"], comment: nil)
      /// en translation: Message
      /// 
      /// Locales: en
      static let lbl_message = Rswift.StringResource(key: "lbl_message", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en"], comment: nil)
      /// en translation: More
      /// 
      /// Locales: en
      static let more = Rswift.StringResource(key: "more", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en"], comment: nil)
      /// en translation: Next
      /// 
      /// Locales: en
      static let next = Rswift.StringResource(key: "next", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en"], comment: nil)
      /// en translation: OK
      /// 
      /// Locales: en
      static let ok = Rswift.StringResource(key: "ok", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en"], comment: nil)
      /// en translation: Open
      /// 
      /// Locales: en
      static let `open` = Rswift.StringResource(key: "open", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en"], comment: nil)
      /// en translation: Open Google Authenticator to generate 2FA code with secret: %@
      /// 
      /// Locales: en
      static let lbl_tfa_secret_authenticator = Rswift.StringResource(key: "lbl_tfa_secret_authenticator", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en"], comment: nil)
      /// en translation: Password
      /// 
      /// Locales: en
      static let password = Rswift.StringResource(key: "password", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en"], comment: nil)
      /// en translation: Please confirm email to continue the registration process
      /// 
      /// Locales: en
      static let lbl_email_confirmation = Rswift.StringResource(key: "lbl_email_confirmation", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en"], comment: nil)
      /// en translation: Please write down and safely store this phrase. It's the ONLY WAY to retrieve your wallet.
      /// 
      /// Locales: en
      static let lbl_mnemonic_title = Rswift.StringResource(key: "lbl_mnemonic_title", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en"], comment: nil)
      /// en translation: Receive
      /// 
      /// Locales: en
      static let receive = Rswift.StringResource(key: "receive", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en"], comment: nil)
      /// en translation: Recommend
      /// 
      /// Locales: en
      static let lbl_recommend = Rswift.StringResource(key: "lbl_recommend", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en"], comment: nil)
      /// en translation: Resend confirmation mail
      /// 
      /// Locales: en
      static let email_resend_confirmation = Rswift.StringResource(key: "email_resend_confirmation", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en"], comment: nil)
      /// en translation: Save
      /// 
      /// Locales: en
      static let lbl_save = Rswift.StringResource(key: "lbl_save", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en"], comment: nil)
      /// en translation: Save
      /// 
      /// Locales: en
      static let save = Rswift.StringResource(key: "save", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en"], comment: nil)
      /// en translation: Scan
      /// 
      /// Locales: en
      static let scan = Rswift.StringResource(key: "scan", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en"], comment: nil)
      /// en translation: Sell
      /// 
      /// Locales: en
      static let sell = Rswift.StringResource(key: "sell", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en"], comment: nil)
      /// en translation: Send
      /// 
      /// Locales: en
      static let send = Rswift.StringResource(key: "send", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en"], comment: nil)
      /// en translation: Settings
      /// 
      /// Locales: en
      static let settings = Rswift.StringResource(key: "settings", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en"], comment: nil)
      /// en translation: Sign up
      /// 
      /// Locales: en
      static let signup = Rswift.StringResource(key: "signup", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en"], comment: nil)
      /// en translation: Something went wrong. Try again, please.
      /// 
      /// Locales: en
      static let sign_in_error_msg = Rswift.StringResource(key: "sign_in_error_msg", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en"], comment: nil)
      /// en translation: Submit
      /// 
      /// Locales: en
      static let submit = Rswift.StringResource(key: "submit", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en"], comment: nil)
      /// en translation: Two Factor code
      /// 
      /// Locales: en
      static let tfa_code = Rswift.StringResource(key: "tfa_code", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en"], comment: nil)
      /// en translation: Unexpected data type
      /// 
      /// Locales: en
      static let unexpected_data_type = Rswift.StringResource(key: "unexpected_data_type", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en"], comment: nil)
      /// en translation: User is not logged in
      /// 
      /// Locales: en
      static let user_not_logged_in = Rswift.StringResource(key: "user_not_logged_in", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en"], comment: nil)
      /// en translation: User specific data
      /// 
      /// Locales: en
      static let user_data_title = Rswift.StringResource(key: "user_data_title", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en"], comment: nil)
      /// en translation: Username
      /// 
      /// Locales: en
      static let username = Rswift.StringResource(key: "username", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en"], comment: nil)
      /// en translation: Withdraw money
      /// 
      /// Locales: en
      static let withdraw = Rswift.StringResource(key: "withdraw", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en"], comment: nil)
      /// en translation: Wrong account or password
      /// 
      /// Locales: en
      static let bad_credentials = Rswift.StringResource(key: "bad_credentials", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en"], comment: nil)
      /// en translation: one day ago
      /// 
      /// Locales: en
      static let lbl_moment_day_count = Rswift.StringResource(key: "lbl_moment_day_count", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en"], comment: nil)
      /// en translation: one hour ago
      /// 
      /// Locales: en
      static let lbl_moment_hour_count = Rswift.StringResource(key: "lbl_moment_hour_count", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en"], comment: nil)
      /// en translation: one minute ago
      /// 
      /// Locales: en
      static let lbl_moment_minute_count = Rswift.StringResource(key: "lbl_moment_minute_count", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en"], comment: nil)
      /// en translation: one month ago
      /// 
      /// Locales: en
      static let lbl_moment_month_count = Rswift.StringResource(key: "lbl_moment_month_count", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en"], comment: nil)
      /// en translation: one second ago
      /// 
      /// Locales: en
      static let lbl_moment_second_count = Rswift.StringResource(key: "lbl_moment_second_count", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en"], comment: nil)
      /// en translation: one week ago
      /// 
      /// Locales: en
      static let lbl_moment_week_count = Rswift.StringResource(key: "lbl_moment_week_count", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en"], comment: nil)
      /// en translation: one year ago
      /// 
      /// Locales: en
      static let lbl_moment_year_count = Rswift.StringResource(key: "lbl_moment_year_count", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en"], comment: nil)
      
      /// en translation: %1$d days ago
      /// 
      /// Locales: en
      static func xMoment_days(_ value1: Int) -> String {
        return String(format: NSLocalizedString("x-moment_days", bundle: R.hostingBundle, comment: ""), locale: R.applicationLocale, value1)
      }
      
      /// en translation: %1$d hours ago
      /// 
      /// Locales: en
      static func xMoment_hours(_ value1: Int) -> String {
        return String(format: NSLocalizedString("x-moment_hours", bundle: R.hostingBundle, comment: ""), locale: R.applicationLocale, value1)
      }
      
      /// en translation: %1$d minutes ago
      /// 
      /// Locales: en
      static func xMoment_minutes(_ value1: Int) -> String {
        return String(format: NSLocalizedString("x-moment_minutes", bundle: R.hostingBundle, comment: ""), locale: R.applicationLocale, value1)
      }
      
      /// en translation: %1$d months ago
      /// 
      /// Locales: en
      static func xMoment_months(_ value1: Int) -> String {
        return String(format: NSLocalizedString("x-moment_months", bundle: R.hostingBundle, comment: ""), locale: R.applicationLocale, value1)
      }
      
      /// en translation: %1$d seconds ago
      /// 
      /// Locales: en
      static func xMoment_seconds(_ value1: Int) -> String {
        return String(format: NSLocalizedString("x-moment_seconds", bundle: R.hostingBundle, comment: ""), locale: R.applicationLocale, value1)
      }
      
      /// en translation: %1$d weeks ago
      /// 
      /// Locales: en
      static func xMoment_weeks(_ value1: Int) -> String {
        return String(format: NSLocalizedString("x-moment_weeks", bundle: R.hostingBundle, comment: ""), locale: R.applicationLocale, value1)
      }
      
      /// en translation: %1$d years ago
      /// 
      /// Locales: en
      static func xMoment_years(_ value1: Int) -> String {
        return String(format: NSLocalizedString("x-moment_years", bundle: R.hostingBundle, comment: ""), locale: R.applicationLocale, value1)
      }
      
      /// en translation: Account specific data
      /// 
      /// Locales: en
      static func account_data_title(_: Void = ()) -> String {
        return NSLocalizedString("account_data_title", bundle: R.hostingBundle, comment: "")
      }
      
      /// en translation: Already confirmed
      /// 
      /// Locales: en
      static func email_already_confirmed(_: Void = ()) -> String {
        return NSLocalizedString("email_already_confirmed", bundle: R.hostingBundle, comment: "")
      }
      
      /// en translation: Anonymous
      /// 
      /// Locales: en
      static func unknown(_: Void = ()) -> String {
        return NSLocalizedString("unknown", bundle: R.hostingBundle, comment: "")
      }
      
      /// en translation: Autogenerated 2FA code with secret: %@
      /// 
      /// Locales: en
      static func lbl_tfa_secret_hint(_ value1: String) -> String {
        return String(format: NSLocalizedString("lbl_tfa_secret_hint", bundle: R.hostingBundle, comment: ""), locale: R.applicationLocale, value1)
      }
      
      /// en translation: Back
      /// 
      /// Locales: en
      static func back(_: Void = ()) -> String {
        return NSLocalizedString("back", bundle: R.hostingBundle, comment: "")
      }
      
      /// en translation: Cancel
      /// 
      /// Locales: en
      static func cancel(_: Void = ()) -> String {
        return NSLocalizedString("cancel", bundle: R.hostingBundle, comment: "")
      }
      
      /// en translation: Close
      /// 
      /// Locales: en
      static func close(_: Void = ()) -> String {
        return NSLocalizedString("close", bundle: R.hostingBundle, comment: "")
      }
      
      /// en translation: Delete
      /// 
      /// Locales: en
      static func delete(_: Void = ()) -> String {
        return NSLocalizedString("delete", bundle: R.hostingBundle, comment: "")
      }
      
      /// en translation: Delete
      /// 
      /// Locales: en
      static func lbl_delete(_: Void = ()) -> String {
        return NSLocalizedString("lbl_delete", bundle: R.hostingBundle, comment: "")
      }
      
      /// en translation: Deposit money
      /// 
      /// Locales: en
      static func deposit(_: Void = ()) -> String {
        return NSLocalizedString("deposit", bundle: R.hostingBundle, comment: "")
      }
      
      /// en translation: Error
      /// 
      /// Locales: en
      static func error(_: Void = ()) -> String {
        return NSLocalizedString("error", bundle: R.hostingBundle, comment: "")
      }
      
      /// en translation: Get Started
      /// 
      /// Locales: en
      static func get_started_button(_: Void = ()) -> String {
        return NSLocalizedString("get_started_button", bundle: R.hostingBundle, comment: "")
      }
      
      /// en translation: I have written it down
      /// 
      /// Locales: en
      static func lbl_mnemonic_button_title(_: Void = ()) -> String {
        return NSLocalizedString("lbl_mnemonic_button_title", bundle: R.hostingBundle, comment: "")
      }
      
      /// en translation: Invalid request
      /// 
      /// Locales: en
      static func invalid_request(_: Void = ()) -> String {
        return NSLocalizedString("invalid_request", bundle: R.hostingBundle, comment: "")
      }
      
      /// en translation: Let's go
      /// 
      /// Locales: en
      static func go(_: Void = ()) -> String {
        return NSLocalizedString("go", bundle: R.hostingBundle, comment: "")
      }
      
      /// en translation: Log Out
      /// 
      /// Locales: en
      static func logout(_: Void = ()) -> String {
        return NSLocalizedString("logout", bundle: R.hostingBundle, comment: "")
      }
      
      /// en translation: Login
      /// 
      /// Locales: en
      static func login(_: Void = ()) -> String {
        return NSLocalizedString("login", bundle: R.hostingBundle, comment: "")
      }
      
      /// en translation: Message
      /// 
      /// Locales: en
      static func lbl_message(_: Void = ()) -> String {
        return NSLocalizedString("lbl_message", bundle: R.hostingBundle, comment: "")
      }
      
      /// en translation: More
      /// 
      /// Locales: en
      static func more(_: Void = ()) -> String {
        return NSLocalizedString("more", bundle: R.hostingBundle, comment: "")
      }
      
      /// en translation: Next
      /// 
      /// Locales: en
      static func next(_: Void = ()) -> String {
        return NSLocalizedString("next", bundle: R.hostingBundle, comment: "")
      }
      
      /// en translation: OK
      /// 
      /// Locales: en
      static func ok(_: Void = ()) -> String {
        return NSLocalizedString("ok", bundle: R.hostingBundle, comment: "")
      }
      
      /// en translation: Open
      /// 
      /// Locales: en
      static func `open`(_: Void = ()) -> String {
        return NSLocalizedString("open", bundle: R.hostingBundle, comment: "")
      }
      
      /// en translation: Open Google Authenticator to generate 2FA code with secret: %@
      /// 
      /// Locales: en
      static func lbl_tfa_secret_authenticator(_ value1: String) -> String {
        return String(format: NSLocalizedString("lbl_tfa_secret_authenticator", bundle: R.hostingBundle, comment: ""), locale: R.applicationLocale, value1)
      }
      
      /// en translation: Password
      /// 
      /// Locales: en
      static func password(_: Void = ()) -> String {
        return NSLocalizedString("password", bundle: R.hostingBundle, comment: "")
      }
      
      /// en translation: Please confirm email to continue the registration process
      /// 
      /// Locales: en
      static func lbl_email_confirmation(_: Void = ()) -> String {
        return NSLocalizedString("lbl_email_confirmation", bundle: R.hostingBundle, comment: "")
      }
      
      /// en translation: Please write down and safely store this phrase. It's the ONLY WAY to retrieve your wallet.
      /// 
      /// Locales: en
      static func lbl_mnemonic_title(_: Void = ()) -> String {
        return NSLocalizedString("lbl_mnemonic_title", bundle: R.hostingBundle, comment: "")
      }
      
      /// en translation: Receive
      /// 
      /// Locales: en
      static func receive(_: Void = ()) -> String {
        return NSLocalizedString("receive", bundle: R.hostingBundle, comment: "")
      }
      
      /// en translation: Recommend
      /// 
      /// Locales: en
      static func lbl_recommend(_: Void = ()) -> String {
        return NSLocalizedString("lbl_recommend", bundle: R.hostingBundle, comment: "")
      }
      
      /// en translation: Resend confirmation mail
      /// 
      /// Locales: en
      static func email_resend_confirmation(_: Void = ()) -> String {
        return NSLocalizedString("email_resend_confirmation", bundle: R.hostingBundle, comment: "")
      }
      
      /// en translation: Save
      /// 
      /// Locales: en
      static func lbl_save(_: Void = ()) -> String {
        return NSLocalizedString("lbl_save", bundle: R.hostingBundle, comment: "")
      }
      
      /// en translation: Save
      /// 
      /// Locales: en
      static func save(_: Void = ()) -> String {
        return NSLocalizedString("save", bundle: R.hostingBundle, comment: "")
      }
      
      /// en translation: Scan
      /// 
      /// Locales: en
      static func scan(_: Void = ()) -> String {
        return NSLocalizedString("scan", bundle: R.hostingBundle, comment: "")
      }
      
      /// en translation: Sell
      /// 
      /// Locales: en
      static func sell(_: Void = ()) -> String {
        return NSLocalizedString("sell", bundle: R.hostingBundle, comment: "")
      }
      
      /// en translation: Send
      /// 
      /// Locales: en
      static func send(_: Void = ()) -> String {
        return NSLocalizedString("send", bundle: R.hostingBundle, comment: "")
      }
      
      /// en translation: Settings
      /// 
      /// Locales: en
      static func settings(_: Void = ()) -> String {
        return NSLocalizedString("settings", bundle: R.hostingBundle, comment: "")
      }
      
      /// en translation: Sign up
      /// 
      /// Locales: en
      static func signup(_: Void = ()) -> String {
        return NSLocalizedString("signup", bundle: R.hostingBundle, comment: "")
      }
      
      /// en translation: Something went wrong. Try again, please.
      /// 
      /// Locales: en
      static func sign_in_error_msg(_: Void = ()) -> String {
        return NSLocalizedString("sign_in_error_msg", bundle: R.hostingBundle, comment: "")
      }
      
      /// en translation: Submit
      /// 
      /// Locales: en
      static func submit(_: Void = ()) -> String {
        return NSLocalizedString("submit", bundle: R.hostingBundle, comment: "")
      }
      
      /// en translation: Two Factor code
      /// 
      /// Locales: en
      static func tfa_code(_: Void = ()) -> String {
        return NSLocalizedString("tfa_code", bundle: R.hostingBundle, comment: "")
      }
      
      /// en translation: Unexpected data type
      /// 
      /// Locales: en
      static func unexpected_data_type(_: Void = ()) -> String {
        return NSLocalizedString("unexpected_data_type", bundle: R.hostingBundle, comment: "")
      }
      
      /// en translation: User is not logged in
      /// 
      /// Locales: en
      static func user_not_logged_in(_: Void = ()) -> String {
        return NSLocalizedString("user_not_logged_in", bundle: R.hostingBundle, comment: "")
      }
      
      /// en translation: User specific data
      /// 
      /// Locales: en
      static func user_data_title(_: Void = ()) -> String {
        return NSLocalizedString("user_data_title", bundle: R.hostingBundle, comment: "")
      }
      
      /// en translation: Username
      /// 
      /// Locales: en
      static func username(_: Void = ()) -> String {
        return NSLocalizedString("username", bundle: R.hostingBundle, comment: "")
      }
      
      /// en translation: Withdraw money
      /// 
      /// Locales: en
      static func withdraw(_: Void = ()) -> String {
        return NSLocalizedString("withdraw", bundle: R.hostingBundle, comment: "")
      }
      
      /// en translation: Wrong account or password
      /// 
      /// Locales: en
      static func bad_credentials(_: Void = ()) -> String {
        return NSLocalizedString("bad_credentials", bundle: R.hostingBundle, comment: "")
      }
      
      /// en translation: one day ago
      /// 
      /// Locales: en
      static func lbl_moment_day_count(_: Void = ()) -> String {
        return NSLocalizedString("lbl_moment_day_count", bundle: R.hostingBundle, comment: "")
      }
      
      /// en translation: one hour ago
      /// 
      /// Locales: en
      static func lbl_moment_hour_count(_: Void = ()) -> String {
        return NSLocalizedString("lbl_moment_hour_count", bundle: R.hostingBundle, comment: "")
      }
      
      /// en translation: one minute ago
      /// 
      /// Locales: en
      static func lbl_moment_minute_count(_: Void = ()) -> String {
        return NSLocalizedString("lbl_moment_minute_count", bundle: R.hostingBundle, comment: "")
      }
      
      /// en translation: one month ago
      /// 
      /// Locales: en
      static func lbl_moment_month_count(_: Void = ()) -> String {
        return NSLocalizedString("lbl_moment_month_count", bundle: R.hostingBundle, comment: "")
      }
      
      /// en translation: one second ago
      /// 
      /// Locales: en
      static func lbl_moment_second_count(_: Void = ()) -> String {
        return NSLocalizedString("lbl_moment_second_count", bundle: R.hostingBundle, comment: "")
      }
      
      /// en translation: one week ago
      /// 
      /// Locales: en
      static func lbl_moment_week_count(_: Void = ()) -> String {
        return NSLocalizedString("lbl_moment_week_count", bundle: R.hostingBundle, comment: "")
      }
      
      /// en translation: one year ago
      /// 
      /// Locales: en
      static func lbl_moment_year_count(_: Void = ()) -> String {
        return NSLocalizedString("lbl_moment_year_count", bundle: R.hostingBundle, comment: "")
      }
      
      fileprivate init() {}
    }
    
    fileprivate init() {}
  }
  
  fileprivate struct intern: Rswift.Validatable {
    fileprivate static func validate() throws {
      // There are no resources to validate
    }
    
    fileprivate init() {}
  }
  
  fileprivate class Class {}
  
  fileprivate init() {}
}

struct _R {
  struct nib {
    fileprivate init() {}
  }
  
  struct storyboard {
    struct launchScreen: Rswift.StoryboardResourceWithInitialControllerType {
      typealias InitialController = UIKit.UIViewController
      
      let bundle = R.hostingBundle
      let name = "LaunchScreen"
      
      fileprivate init() {}
    }
    
    fileprivate init() {}
  }
  
  fileprivate init() {}
}
