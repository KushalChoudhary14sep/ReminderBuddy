//
//  File.swift
//  ReminderBuddy
//
//  Created by Kaushal Chaudhary on 15/06/24.
//

import Foundation
@objc protocol TextFieldInputValidatorDelegates: AnyObject {
    @objc optional func didEmailValidationFailed(with error: EmailValidationError)
    @objc optional func didPasswordValidationFailed(with error: PasswordValidationError)
    @objc optional func didMobileNumberValidationFailed(with error: MobileNumberVaidationError)
    @objc optional func didConfirmPasswordValidationFailed()
    @objc optional func didFirstNameValidationFailed()
    @objc optional func didLastNameValidationFailed()
}

@objc enum EmailValidationError: Int {
    case invalidEmail = 0
    case invalidEmailDidgitCount = 1
}

@objc enum PasswordValidationError: Int {
    case invalidPassword = 0
    case invalidPasswordDigitCount = 1
}

@objc enum MobileNumberVaidationError: Int {
    case invalidPhoneNumber = 0
    case invalidPhoneNumberDigitCount = 1
}

class TextFieldInputValidator {
    weak var delegate: TextFieldInputValidatorDelegates?

    func isValidEmail(email: String?) -> Bool {
        guard let email = email, email.count >= 3 else {
            delegate?.didEmailValidationFailed?(with: .invalidEmailDidgitCount)
            return false
        }

        let emailRegex = "[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        if emailPredicate.evaluate(with: email) {
            return true
        } else {
            delegate?.didEmailValidationFailed?(with: .invalidEmail)
            return false
        }
    }

    func isValidPassword(password: String?) -> Bool {
        guard let password = password, password.count >= 8 else {
            delegate?.didPasswordValidationFailed?(with: .invalidPasswordDigitCount)
            return false
        }
        return true
    }

    func isValidConfirmPassword(password: String?, confirmPassword: String?) -> Bool {
        guard let password = password, let confirmPassword = confirmPassword else {
            delegate?.didConfirmPasswordValidationFailed?()
            return false
        }
        guard password == confirmPassword else {
            delegate?.didConfirmPasswordValidationFailed?()
            return false
        }
        return true
    }
    
    func isValidFirstName(firstName: String?) -> Bool {
        guard let firstName = firstName, firstName.count >= 3 else {
            delegate?.didFirstNameValidationFailed?()
            return false
        }
        return true
    }
    
    func isValidLastName(lastName: String?) -> Bool {
        guard let lastName = lastName, lastName.count >= 3 else {
            delegate?.didLastNameValidationFailed?()
            return false
        }
        return true
    }
    
    func isValidPhoneNumber(phoneNumber: String?) -> Bool {
        guard let phoneNumber = phoneNumber, phoneNumber.count >= 8 else {
            delegate?.didMobileNumberValidationFailed?(with: .invalidPhoneNumberDigitCount)
            return false
        }
        return true
    }
}
