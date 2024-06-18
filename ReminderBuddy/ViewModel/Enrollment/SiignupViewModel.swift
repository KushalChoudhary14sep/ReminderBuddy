//
//  SiignupViewModel.swift
//  ReminderBuddy
//
//  Created by Kaushal Chaudhary on 15/06/24.
//

import Foundation

protocol SignupViewModelDelegates: TextFieldInputValidatorDelegates {
    func didPostSignupSuccessfully()
    func didPostSignupFailed(with error: SignupStatus.SignupError)
}

class SignupViewModel {
    let validator = TextFieldInputValidator()
    init() {
        validator.delegate = self
//        AnalyticsEventManager.shared.logEvent(.signupViewed)
    }
    weak var delegate: SignupViewModelDelegates?
    
    var firstName, lastName, email, password, confirmPassword: String?
}

// Validations
extension SignupViewModel {
    func isValidCredentials() -> Bool {
        return isValidFirstName() && isValidLastName() && isValidEmail() && isValidPassword() && isValidConfirmPassword()
    }
    
    private func isValidFirstName() -> Bool {
        return validator.isValidFirstName(firstName: firstName)
    }
    
    private func isValidLastName() -> Bool {
        return validator.isValidLastName(lastName: lastName)
    }
    
    private func isValidEmail() -> Bool {
        return validator.isValidEmail(email: email)
    }
    
    private func isValidPassword() -> Bool {
        return validator.isValidPassword(password: password)
    }
    
    private func isValidConfirmPassword() -> Bool {
        return validator.isValidConfirmPassword(password: password, confirmPassword: confirmPassword)
    }
}

// Post Signup
extension SignupViewModel {
    func postSignup() {
        guard let email = email, let password = password, let firstName = firstName, let lastName = lastName else { return }
        
        UserManager.shared.signupUser(email: email, password: password, firstName: firstName, lastName: lastName) { [weak self] status in
            guard let self = self else { return }
            switch status {
            case .success:
                self.delegate?.didPostSignupSuccessfully()
//                AnalyticsEventManager.shared.logEvent(.userSignedIn(with: ["email_ID" : "\(email)", "first_name" : "\(firstName)", "last_name" : "\(lastName)"]))
            case .failiure(let error):
                switch error {
                case .emailExist:
                    self.delegate?.didPostSignupFailed(with: .emailExist)
                case .unknown:
                    self.delegate?.didPostSignupFailed(with: .unknown)
                }
            }
        }
    }
}

// Text Field Input Validator Delegates
extension SignupViewModel: TextFieldInputValidatorDelegates {
    func didEmailValidationFailed(with error: EmailValidationError) {
        delegate?.didEmailValidationFailed?(with: error)
    }
    
    func didPasswordValidationFailed(with error: PasswordValidationError) {
        delegate?.didPasswordValidationFailed?(with: error)
    }
    
    func didFirstNameValidationFailed() {
        delegate?.didFirstNameValidationFailed?()
    }
    
    func didLastNameValidationFailed() {
        delegate?.didLastNameValidationFailed?()
    }
    
    func didConfirmPasswordValidationFailed() {
        delegate?.didConfirmPasswordValidationFailed?()
    }
}
