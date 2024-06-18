//
//  LoginViewController.swift
//  ReminderBuddy
//
//  Created by Kaushal Chaudhary on 15/06/24.
//

import Foundation
import UIKit

import UIKit

class LoginViewController: UIViewController {
    private let viewModel = LoginViewModel()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        setupViews()
    }
        
    static func showLogin() {
        let vc = LoginViewController()
        let navigation = UINavigationController(rootViewController: vc)
        navigation.isNavigationBarHidden = true
        navigation.modalPresentationStyle = .fullScreen
        AppNavigationDelegate.shared.navigationController.present(navigation, animated: true)
    }
    
    private lazy var baseImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = Asset.Assets.enrollementBackground.image.withTintColor(Asset.ColorAssets.primaryColor1.color)
        return view
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var baseContentView: UIView = {
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
    
    private lazy var loginTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.attributedText = NSAttributedString.setAttributedText(text: Local.Login.HeyThere.title, font: .appfont(font: .bold, size: 24), color: .black)
        return label
    }()
    
    private lazy var loginSubTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.attributedText = NSAttributedString.setAttributedText(text: Local.Login.LoginToProceed.title, font: .appfont(font: .medium, size: 14), color: .darkText)
        return label
    }()
    
    private lazy var emailTextField: AppPrimaryTextField = {
        let textField = AppPrimaryTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = Local.Enrollment.emailIDPlaceholder
        textField.valueType = .email
        textField.keyboardType = .emailAddress
        textField.textContentType = .emailAddress
        textField.maxLength = 40
        textField.delegate = self
        return textField
    }()
    
    private lazy var passwordTextField: PasswordTextField = {
        let textField = PasswordTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = Local.Enrollment.passwordPlaceholder
        textField.maxLength = 20
        textField.textContentType = .password
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
                viewModel.postLogin()
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
    
    private lazy var noExistingAccountStackView: UIStackView = {
        let stackview = UIStackView()
        stackview.translatesAutoresizingMaskIntoConstraints = false
        stackview.axis = .horizontal
        stackview.alignment = .fill
        stackview.distribution = .fill
        stackview.spacing = 6
        return stackview
    }()
    
    private lazy var noExistingAccountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.attributedText = NSAttributedString.setAttributedText(text: Local.Login.NoAccount.title, font: .appfont(font: .medium, size: 14), color: .lightGray)
        return label
    }()
    
    private lazy var noExistingAccountButton: TextOnlyButton = {
        let button = TextOnlyButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addAction(UIAction(handler: { [unowned self] _ in
            let vc = SignupViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }), for: .touchUpInside)
        button.setAttributedTitle(NSAttributedString.setAttributedText(text: Local.Login.SignupButton.title, font: .appfont(font: .semiBold, size: 14), color: Asset.ColorAssets.primaryColor1.color), for: .normal)
        return button
    }()
}

private extension LoginViewController {
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
              
        scrollView.addSubview(baseContentView)
        NSLayoutConstraint.activate([
            baseContentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            baseContentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            baseContentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            baseContentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            baseContentView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1)
        ])
        
        
        let height = baseContentView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1)
        height.priority = .init(250)
        height.isActive = true
        
        
        baseContentView.addSubview(emptyView)
        NSLayoutConstraint.activate([
            emptyView.leadingAnchor.constraint(equalTo: baseContentView.leadingAnchor),
            emptyView.trailingAnchor.constraint(equalTo: baseContentView.trailingAnchor),
            emptyView.topAnchor.constraint(equalTo: baseContentView.topAnchor),
        ])
        
        baseContentView.addSubview(loginTitleLabel)
        NSLayoutConstraint.activate([
            loginTitleLabel.centerXAnchor.constraint(equalTo: baseContentView.centerXAnchor),
            loginTitleLabel.topAnchor.constraint(equalTo: emptyView.bottomAnchor)
        ])
        
        baseContentView.addSubview(loginSubTitleLabel)
        NSLayoutConstraint.activate([
            loginSubTitleLabel.centerXAnchor.constraint(equalTo: baseContentView.centerXAnchor),
            loginSubTitleLabel.topAnchor.constraint(equalTo: loginTitleLabel.bottomAnchor, constant: 4)
        ])

        baseContentView.addSubview(emailTextField)
        baseContentView.addSubview(passwordTextField)
        NSLayoutConstraint.activate([
            emailTextField.topAnchor.constraint(equalTo: loginSubTitleLabel.bottomAnchor, constant: 32),
            emailTextField.leadingAnchor.constraint(equalTo: baseContentView.leadingAnchor, constant: 16),
            emailTextField.trailingAnchor.constraint(equalTo: baseContentView.trailingAnchor, constant: -16),
            emailTextField.heightAnchor.constraint(equalToConstant: 46),
            
            passwordTextField.leadingAnchor.constraint(equalTo: baseContentView.leadingAnchor, constant: 16),
            passwordTextField.trailingAnchor.constraint(equalTo: baseContentView.trailingAnchor, constant: -16),
            passwordTextField.heightAnchor.constraint(equalTo: emailTextField.heightAnchor, multiplier: 1),
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20)
        ])
        
        baseContentView.addSubview(continueButton)
        NSLayoutConstraint.activate([
            continueButton.heightAnchor.constraint(equalToConstant: 48),
            continueButton.leadingAnchor.constraint(equalTo: passwordTextField.leadingAnchor),
            continueButton.trailingAnchor.constraint(equalTo: passwordTextField.trailingAnchor),
            continueButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 24)
        ])
        
        baseContentView.addSubview(orLabel)
        NSLayoutConstraint.activate([
            orLabel.centerXAnchor.constraint(equalTo: baseContentView.centerXAnchor),
            orLabel.topAnchor.constraint(equalTo: continueButton.bottomAnchor, constant: 24)
        ])
        
        noExistingAccountStackView.addArrangedSubview(noExistingAccountLabel)
        noExistingAccountStackView.addArrangedSubview(noExistingAccountButton)
        baseContentView.addSubview(noExistingAccountStackView)
        NSLayoutConstraint.activate([
            noExistingAccountStackView.centerXAnchor.constraint(equalTo: baseContentView.centerXAnchor),
            noExistingAccountStackView.topAnchor.constraint(equalTo: orLabel.bottomAnchor, constant: 24),
            noExistingAccountStackView.bottomAnchor.constraint(lessThanOrEqualTo: baseContentView.bottomAnchor, constant: -12)
        ])
        
        NSLayoutConstraint.activate([
            baseImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4),
            emptyView.heightAnchor.constraint(equalTo: baseImageView.heightAnchor, multiplier: 1)
        ])
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textField {
        case emailTextField:
            let currentString: NSString = (textField.text ?? "") as NSString
            let newString: NSString =  currentString.replacingCharacters(in: range, with: string) as NSString
            viewModel.email = newString as String
        case passwordTextField:
            let currentString: NSString = (textField.text ?? "") as NSString
            let newString: NSString =  currentString.replacingCharacters(in: range, with: string) as NSString
            viewModel.password = newString as String
        default:
            break;
        }
        return true
    }
}

extension LoginViewController: LoginViewModelDelegates {
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
    
    func didPostLoginSuccessfully() {
        continueButton.loadingIndicator(false)
        self.navigationController?.dismiss(animated: true)
        AppNavigationDelegate.shared.start()
    }
    
    func didPostLoginFailed() {
        continueButton.loadingIndicator(false)
        ErrorDisplay.error(message: Local.Login.Failiure.error)
    }
}
