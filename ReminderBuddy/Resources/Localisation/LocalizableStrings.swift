// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum Local {
  internal enum Enrollment {
    /// Email
    internal static let emailIDPlaceholder = Local.tr("Localizable", "Enrollment.EmailIDPlaceholder", fallback: "Email")
    /// First Name
    internal static let firstNamePlaceholder = Local.tr("Localizable", "Enrollment.FirstNamePlaceholder", fallback: "First Name")
    /// Last Name
    internal static let lastNamePlaceholder = Local.tr("Localizable", "Enrollment.LastNamePlaceholder", fallback: "Last Name")
    /// Password
    internal static let passwordPlaceholder = Local.tr("Localizable", "Enrollment.PasswordPlaceholder", fallback: "Password")
    /// Minimum 8 character required.
    internal static let validPasswordDigitCountError = Local.tr("Localizable", "Enrollment.ValidPasswordDigitCountError", fallback: "Minimum 8 character required.")
    internal enum AlreadyRegisteredFailiure {
      /// Accout already exists.
      internal static let error = Local.tr("Localizable", "Enrollment.AlreadyRegisteredFailiure.Error", fallback: "Accout already exists.")
    }
    internal enum ContinueButton {
      /// Continue
      internal static let title = Local.tr("Localizable", "Enrollment.ContinueButton.Title", fallback: "Continue")
    }
    internal enum Emailfailiure {
      /// Please check your email.
      internal static let error = Local.tr("Localizable", "Enrollment.Emailfailiure.Error", fallback: "Please check your email.")
    }
    internal enum Or {
      /// OR
      internal static let title = Local.tr("Localizable", "Enrollment.Or.Title", fallback: "OR")
    }
    internal enum Passwordfailiure {
      /// Please check your password.
      internal static let error = Local.tr("Localizable", "Enrollment.Passwordfailiure.Error", fallback: "Please check your password.")
    }
    internal enum ValidConfirmPassword {
      /// Confirm Password must be same as Password
      internal static let error = Local.tr("Localizable", "Enrollment.ValidConfirmPassword.Error", fallback: "Confirm Password must be same as Password")
    }
    internal enum ValidEmail {
      /// Please enter valid email.
      internal static let error = Local.tr("Localizable", "Enrollment.ValidEmail.Error", fallback: "Please enter valid email.")
    }
    internal enum ValidEmailDigitCount {
      /// Minimum 3 letters required.
      internal static let error = Local.tr("Localizable", "Enrollment.ValidEmailDigitCount.Error", fallback: "Minimum 3 letters required.")
    }
    internal enum ValidPassword {
      /// Please enter valid password. Password must contain at least one digit, one uppercase letter, and one special character.
      internal static let error = Local.tr("Localizable", "Enrollment.ValidPassword.Error", fallback: "Please enter valid password. Password must contain at least one digit, one uppercase letter, and one special character.")
    }
  }
  internal enum Home {
    internal enum TaskList {
      /// No tasks yet. Create one and Add reminders!
      internal static let placeholder = Local.tr("Localizable", "Home.TaskList.Placeholder", fallback: "No tasks yet. Create one and Add reminders!")
    }
  }
  internal enum Login {
    /// Log In
    internal static let title = Local.tr("Localizable", "Login.Title", fallback: "Log In")
    internal enum Failiure {
      /// Please check your login credentials
      internal static let error = Local.tr("Localizable", "Login.Failiure.Error", fallback: "Please check your login credentials")
    }
    internal enum HeyThere {
      /// Hey there!
      internal static let title = Local.tr("Localizable", "Login.HeyThere.Title", fallback: "Hey there!")
    }
    internal enum LoginToProceed {
      /// Please login to proceed
      internal static let title = Local.tr("Localizable", "Login.LoginToProceed.Title", fallback: "Please login to proceed")
    }
    internal enum NoAccount {
      /// Don’t have an account yet?
      internal static let title = Local.tr("Localizable", "Login.NoAccount.Title", fallback: "Don’t have an account yet?")
    }
    internal enum SignupButton {
      /// Sign up
      internal static let title = Local.tr("Localizable", "Login.SignupButton.Title", fallback: "Sign up")
    }
  }
  internal enum Signup {
    /// Confirm Password
    internal static let confirmPasswordPlaceholder = Local.tr("Localizable", "Signup.ConfirmPasswordPlaceholder", fallback: "Confirm Password")
    /// Sign Up
    internal static let title = Local.tr("Localizable", "Signup.Title", fallback: "Sign Up")
    internal enum ExistingAccount {
      /// Already have an account?
      internal static let title = Local.tr("Localizable", "Signup.ExistingAccount.Title", fallback: "Already have an account?")
    }
    internal enum LoginButton {
      /// Log in
      internal static let title = Local.tr("Localizable", "Signup.LoginButton.Title", fallback: "Log in")
    }
    internal enum PleaseSsignupToProceed {
      /// Please signup to proceed
      internal static let title = Local.tr("Localizable", "Signup.PleaseSsignupToProceed.Title", fallback: "Please signup to proceed")
    }
  }
  internal enum Tabbar {
    /// Dashboard
    internal static let dashboard = Local.tr("Localizable", "Tabbar.Dashboard", fallback: "Dashboard")
    /// Localizable.strings
    ///   ReminderBuddy
    /// 
    ///   Created by Kaushal Chaudhary on 15/06/24.
    internal static let home = Local.tr("Localizable", "Tabbar.Home", fallback: "Home")
    /// Settings
    internal static let settings = Local.tr("Localizable", "Tabbar.Settings", fallback: "Settings")
  }
  internal enum UnknownFailiure {
    /// Something went wrong.
    internal static let error = Local.tr("Localizable", "UnknownFailiure.Error", fallback: "Something went wrong.")
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension Local {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
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
