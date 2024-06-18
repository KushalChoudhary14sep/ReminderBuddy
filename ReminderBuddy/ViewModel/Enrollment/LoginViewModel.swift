//
//  LoginViewModel.swift
//  ReminderBuddy
//
//  Created by Kushal Chaudhary on 15/06/24.
//

import Foundation

protocol LoginViewModelDelegates: TextFieldInputValidatorDelegates {
    func didPostLoginSuccessfully()
    func didPostLoginFailed(error: LoginStatus.LoginError)
}

class LoginViewModel {

    let validator = TextFieldInputValidator()
    init() {
        validator.delegate = self
//        AnalyticsEventManager.shared.logEvent(.loginViewed)
    }
    weak var delegate: LoginViewModelDelegates?
    
    var email: String?
    var password: String?
}

// Validations
extension LoginViewModel {
    func isValidCredentials() -> Bool {
        return isValidEmail() && isValidPassword()
    }
    
    private func isValidEmail() -> Bool {
        return validator.isValidEmail(email: email)
    }
    
    private func isValidPassword() -> Bool {
        return validator.isValidPassword(password: password)
    }
}

// Post Login
extension LoginViewModel {
    func postLogin() {
        guard let email = email, let password = password else { return }
        UserManager.shared.loginUser(email: email, password: password) { status in
            switch status {
            case .success:
                self.delegate?.didPostLoginSuccessfully()
        //        AnalyticsEventManager.shared.logEvent(.userLoggedIn(with: email))
            case .failiure(let error):
                switch error {
                case .wrongPassword:
                    self.delegate?.didPostLoginFailed(error: .wrongPassword)
                case .userNotFound:
                    self.delegate?.didPostLoginFailed(error: .userNotFound)
                case .unknown:
                    self.delegate?.didPostLoginFailed(error: .unknown)
                }
            }
        }
    }
}

extension LoginViewModel: TextFieldInputValidatorDelegates {
    func didEmailValidationFailed(with error: EmailValidationError) {
        delegate?.didEmailValidationFailed?(with: error)
    }
    
    func didPasswordValidationFailed(with error: PasswordValidationError) {
        delegate?.didPasswordValidationFailed?(with: error)
    }
}
