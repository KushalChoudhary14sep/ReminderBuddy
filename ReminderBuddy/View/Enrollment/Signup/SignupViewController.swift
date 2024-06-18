//
//  SignupViewController.swift
//  ReminderBuddy
//
//  Created by Kaushal Chaudhary on 15/06/24.
//

import Foundation
import UIKit

class SignupViewController: UIViewController {
    private let viewModel = SignupViewModel()
    private let loginViewModel = LoginViewModel()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        loginViewModel.delegate = self
        setupViews()
        self.view.backgroundColor = .white
    }
    
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var emptyView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var baseImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = Asset.Assets.enrollementBackground.image.withTintColor(Asset.ColorAssets.primaryColor1.color)
        return view
    }()
    
    private lazy var signupTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.attributedText = NSAttributedString.setAttributedText(text: Local.Signup.title, font: .appfont(font: .bold, size: 24), color: .black)
        return label
    }()
    
    private lazy var signupSubtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.attributedText = NSAttributedString.setAttributedText(text: Local.Signup.PleaseSsignupToProceed.title, font: .appfont(font: .medium, size: 14), color: .darkGray)
        return label
    }()
    
    private lazy var userNameStackView: UIStackView = {
        let stackview = UIStackView()
        stackview.translatesAutoresizingMaskIntoConstraints = false
        stackview.axis = .horizontal
        stackview.alignment = .fill
        stackview.distribution = .fillEqually
        stackview.spacing = 20
        return stackview
    }()
    
    private lazy var fistNameTextField: AppPrimaryTextField = {
        let textField = AppPrimaryTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = Local.Enrollment.firstNamePlaceholder
        textField.valueType = .onlyLetters
        textField.textContentType = .name
        textField.keyboardType = .alphabet
        textField.maxLength = 20
        textField.delegate = self
        return textField
    }()
    
    private lazy var lastNameTextField: AppPrimaryTextField = {
        let textField = AppPrimaryTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = Local.Enrollment.lastNamePlaceholder
        textField.valueType = .onlyLetters
        textField.textContentType = .name
        textField.keyboardType = .alphabet
        textField.maxLength = 20
        textField.delegate = self
        return textField
    }()
    
    private lazy var emailTextField: AppPrimaryTextField = {
            let textField = AppPrimaryTextField()
            textField.translatesAutoresizingMaskIntoConstraints = false
            textField.placeholder = Local.Enrollment.emailIDPlaceholder
            textField.valueType = .email
            textField.textContentType = .emailAddress
            textField.keyboardType = .emailAddress
            textField.maxLength = 40
            textField.delegate = self
        return textField
    }()
    
    private lazy var passwordTextField: PasswordTextField = {
        let textField = PasswordTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = Local.Enrollment.passwordPlaceholder
        textField.textContentType = .password
        textField.maxLength = 20
        textField.delegate = self
        textField.isSecureTextEnabled = true
        return textField
    }()
    
    private lazy var confirmPasswordTextField: PasswordTextField = {
        let textField = PasswordTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = Local.Signup.confirmPasswordPlaceholder
        textField.textContentType = .password
        textField.maxLength = 20
        textField.delegate = self
        textField.isSecureTextEnabled = true
        return textField
    }()
  

    private lazy var continueButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addAction(UIAction(handler: { [unowned self] _ in
            button.loadingIndicator(true)
            if viewModel.isValidCredentials() {
                viewModel.postSignup()
            }
        }), for: .touchUpInside)
        button.setAttributedTitle(NSAttributedString.setAttributedText(text: Local.Enrollment.ContinueButton.title, font: .appfont(font: .semiBold, size: 16), color: .white), for: .normal)
        button.layer.cornerRadius = 16
        button.backgroundColor = Asset.ColorAssets.primaryColor1.color
        return button
    }()
    
    private lazy var orLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.attributedText = NSAttributedString.setAttributedText(text: Local.Enrollment.Or.title, font: .appfont(font: .medium, size: 14), color: .lightGray)
        return label
    }()
    
    private lazy var existingAccountStackView: UIStackView = {
        let stackview = UIStackView()
        stackview.translatesAutoresizingMaskIntoConstraints = false
        stackview.axis = .horizontal
        stackview.alignment = .fill
        stackview.distribution = .fill
        stackview.spacing = 6
        return stackview
    }()
    
    private lazy var existingAccountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.attributedText = NSAttributedString.setAttributedText(text: Local.Signup.ExistingAccount.title, font: .appfont(font: .medium, size: 14), color: .lightGray)
        return label
    }()
    
    private lazy var existingAccountButton: TextOnlyButton = {
        let button = TextOnlyButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addAction(UIAction(handler: { [unowned self] _ in
            if let vc = self.navigationController?.viewControllers.first(where: { $0 is LoginViewController}) {
                self.navigationController?.popToViewController(vc, animated: true)
            } else {
                self.navigationController?.popViewController(animated: true)
            }
        }), for: .touchUpInside)
        button.setAttributedTitle(NSAttributedString.setAttributedText(text: Local.Signup.LoginButton.title, font: .appfont(font: .semiBold, size: 14), color: Asset.ColorAssets.primaryColor1.color), for: .normal)
        return button
    }()
    
}

private extension SignupViewController {
    private func setupViews() {
        self.view.backgroundColor = .white
        
        view.addSubview(baseImageView)
        NSLayoutConstraint.activate([
            baseImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            baseImageView.topAnchor.constraint(equalTo: view.topAnchor),
            baseImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.widthAnchor.constraint(equalToConstant: view.bounds.width)
        ])
        
        scrollView.addSubview(contentView)
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1)
        ])
        
        let height = contentView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1)
        height.priority = .init(250)
        height.isActive = true
        
        contentView.addSubview(emptyView)
        NSLayoutConstraint.activate([
            emptyView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            emptyView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            emptyView.topAnchor.constraint(equalTo: contentView.topAnchor),
        ])
        
        contentView.addSubview(signupTitleLabel)
        NSLayoutConstraint.activate([
            signupTitleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            signupTitleLabel.topAnchor.constraint(equalTo: emptyView.bottomAnchor)
        ])
        
        contentView.addSubview(signupSubtitleLabel)
        NSLayoutConstraint.activate([
            signupSubtitleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            signupSubtitleLabel.topAnchor.constraint(equalTo: signupTitleLabel.bottomAnchor, constant: 4)
        ])
        
        userNameStackView.addArrangedSubview(fistNameTextField)
        userNameStackView.addArrangedSubview(lastNameTextField)
        contentView.addSubview(userNameStackView)
        NSLayoutConstraint.activate([
            userNameStackView.topAnchor.constraint(equalTo: signupSubtitleLabel.bottomAnchor, constant: 28),
            userNameStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            userNameStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
        ])
        
        contentView.addSubview(emailTextField)
        contentView.addSubview(passwordTextField)
        contentView.addSubview(confirmPasswordTextField)
        NSLayoutConstraint.activate([
            emailTextField.topAnchor.constraint(equalTo: userNameStackView.bottomAnchor, constant: 24),
            emailTextField.leadingAnchor.constraint(equalTo: userNameStackView.leadingAnchor),
            emailTextField.trailingAnchor.constraint(equalTo: userNameStackView.trailingAnchor),
            
            passwordTextField.leadingAnchor.constraint(equalTo: userNameStackView.leadingAnchor),
            passwordTextField.trailingAnchor.constraint(equalTo: userNameStackView.trailingAnchor),
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 24),
            
            confirmPasswordTextField.leadingAnchor.constraint(equalTo: userNameStackView.leadingAnchor),
            confirmPasswordTextField.trailingAnchor.constraint(equalTo: userNameStackView.trailingAnchor),
            confirmPasswordTextField.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 24)
        ])
        
        
        contentView.addSubview(continueButton)
        NSLayoutConstraint.activate([
            continueButton.heightAnchor.constraint(equalToConstant: 48),
            continueButton.leadingAnchor.constraint(equalTo: passwordTextField.leadingAnchor),
            continueButton.trailingAnchor.constraint(equalTo: passwordTextField.trailingAnchor),
            continueButton.topAnchor.constraint(equalTo: confirmPasswordTextField.bottomAnchor, constant: 24)
        ])
        
        contentView.addSubview(orLabel)
        NSLayoutConstraint.activate([
            orLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            orLabel.topAnchor.constraint(equalTo: continueButton.bottomAnchor, constant: 24)
        ])
        
        existingAccountStackView.addArrangedSubview(existingAccountLabel)
        existingAccountStackView.addArrangedSubview(existingAccountButton)
        contentView.addSubview(existingAccountStackView)
        NSLayoutConstraint.activate([
            existingAccountStackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            existingAccountStackView.topAnchor.constraint(equalTo: orLabel.bottomAnchor, constant: 24),
            existingAccountStackView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -12)
        ])
 
        NSLayoutConstraint.activate([
            baseImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4),
            emptyView.heightAnchor.constraint(equalTo: baseImageView.heightAnchor, multiplier: 0.9)
        ])
    }
}

extension SignupViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentString: NSString = (textField.text ?? "") as NSString
        let newString: NSString =  currentString.replacingCharacters(in: range, with: string) as NSString
        switch textField {
        case fistNameTextField:
            viewModel.firstName = newString as String
        case lastNameTextField:
            viewModel.lastName = newString as String
        case emailTextField:
            viewModel.email = newString as String
        case passwordTextField:
            viewModel.password = newString as String
        case confirmPasswordTextField:
            viewModel.confirmPassword = newString as String
        default:
            break;
        }
        return true
    }
}

extension SignupViewController: SignupViewModelDelegates {
    func didPostSignupSuccessfully() {
        loginViewModel.email = viewModel.email
        loginViewModel.password = viewModel.password
        loginViewModel.postLogin()
    }
    
    func didPostSignupFailed(with error: SignupStatus.SignupError) {
        continueButton.loadingIndicator(false)
        switch error{
        case .emailExist:
            ErrorDisplay.error(message: Local.Enrollment.AlreadyRegisteredFailiure.error)
        case .unknown:
            ErrorDisplay.error(message: Local.UnknownFailiure.error)
        }
    }
    
    func didEmailValidationFailed(with error: EmailValidationError) {
        continueButton.loadingIndicator(false)
        self.emailTextField.isError = true
        switch error {
        case .invalidEmail:
            self.emailTextField.error = Local.Enrollment.ValidEmail.error
        case .invalidEmailDidgitCount:
            self.emailTextField.error = Local.Enrollment.ValidEmailDigitCount.error
        }
    }
    
    func didPasswordValidationFailed(with error: PasswordValidationError) {
        continueButton.loadingIndicator(false)
        self.passwordTextField.isError = true
        switch error {
        case .invalidPassword:
            self.passwordTextField.error = Local.Enrollment.ValidPassword.error
        case .invalidPasswordDigitCount:
            self.passwordTextField.error = Local.Enrollment.validPasswordDigitCountError
        }
    }
    
    func didFirstNameValidationFailed() {
        continueButton.loadingIndicator(false)
        self.fistNameTextField.isError = true
        self.fistNameTextField.error = Local.Enrollment.ValidEmailDigitCount.error
    }
    
    func didLastNameValidationFailed() {
        continueButton.loadingIndicator(false)
        self.lastNameTextField.isError = true
        self.lastNameTextField.error = Local.Enrollment.ValidEmailDigitCount.error
    }
    
    func didConfirmPasswordValidationFailed() {
        continueButton.loadingIndicator(false)
        self.confirmPasswordTextField.isError = true
        self.confirmPasswordTextField.error = Local.Enrollment.ValidConfirmPassword.error
    }
}

extension SignupViewController: LoginViewModelDelegates {
    func didPostLoginFailed(error: LoginStatus.LoginError) {
        continueButton.loadingIndicator(false)
        switch error {
        case .wrongPassword:
            ErrorDisplay.error(message: Local.Enrollment.Passwordfailiure.error)
        case .userNotFound:
            ErrorDisplay.error(message: Local.Login.Failiure.error)
        case .unknown:
            ErrorDisplay.error(message: Local.UnknownFailiure.error)
        }
    }
    
    func didPostLoginSuccessfully() {
        continueButton.loadingIndicator(false)
        self.navigationController?.dismiss(animated: true)
        AppNavigationDelegate.shared.gotoRoot()
    }
}
