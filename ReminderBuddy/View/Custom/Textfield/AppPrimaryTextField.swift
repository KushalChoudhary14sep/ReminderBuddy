//
//  AppPrimaryTextField.swift
//  ReminderBuddy
//
//  Created by Kaushal Chaudhary on 15/06/24.
//

import Foundation
import UIKit

extension UITextField {
    typealias StateChangeClosure = (UITextField) -> Void
    typealias TextChangeClosure = (UITextField, String?) -> Void

    private struct AssociatedKeys {
        static var stateChangeClosure = "stateChangeClosure"
        static var textChangeClosure = "textChangeClosure"
    }

    var stateChangeClosure: StateChangeClosure? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.stateChangeClosure) as? StateChangeClosure
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.stateChangeClosure, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            addTarget(self, action: #selector(handleStateChange), for: .editingChanged)
        }
    }

    var textChangeClosure: TextChangeClosure? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.textChangeClosure) as? TextChangeClosure
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.textChangeClosure, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        }
    }

    @objc private func handleStateChange() {
        stateChangeClosure?(self)
    }

    @objc private func handleTextChange() {
        textChangeClosure?(self, text)
    }
}

class TextField: UITextField {
    override func deleteBackward() {
        super.deleteBackward()
        _ = self.delegate?.textField?(self, shouldChangeCharactersIn: .init(), replacementString: self.text ?? "")
    }
    enum ValueType: Int {
        case none
        case onlyLetters
        case onlyNumbers
        case phoneNumber   // Allowed "+0123456789"
        case alphaNumeric
        case fullName      // Allowed letters and space
        case email
    }
    
    @IBInspectable var maxLength: Int = .max
    var valueType: ValueType = ValueType.none
    @IBInspectable var allowedCharInString: String = ""
}

class AddTaskTextField: AppPrimaryTextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = Asset.ColorAssets.primaryColor1.color
        self.textColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class AppPrimaryTextField: TextField {
    @IBDesignable
    class PaddingLabel: UILabel {
        var textEdgeInsets = UIEdgeInsets(top: 4, left: 2, bottom: 2, right: 4) {
            didSet { invalidateIntrinsicContentSize() }
        }
        
        open override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
            let insetRect = bounds.inset(by: textEdgeInsets)
            let textRect = super.textRect(forBounds: insetRect, limitedToNumberOfLines: numberOfLines)
            let invertedInsets = UIEdgeInsets(top: -textEdgeInsets.top, left: -textEdgeInsets.left, bottom: -textEdgeInsets.bottom, right: -textEdgeInsets.right)
            return textRect.inset(by: invertedInsets)
        }
        
        override func drawText(in rect: CGRect) {
            super.drawText(in: rect.inset(by: textEdgeInsets))
        }
        
        @IBInspectable
        var paddingLeft: CGFloat {
            set { textEdgeInsets.left = newValue }
            get { return textEdgeInsets.left }
        }
        
        @IBInspectable
        var paddingRight: CGFloat {
            set { textEdgeInsets.right = newValue }
            get { return textEdgeInsets.right }
        }
        
        @IBInspectable
        var paddingTop: CGFloat {
            set { textEdgeInsets.top = newValue }
            get { return textEdgeInsets.top }
        }
        
        @IBInspectable
        var paddingBottom: CGFloat {
            set { textEdgeInsets.bottom = newValue }
            get { return textEdgeInsets.bottom }
        }
    }

    override var textColor: UIColor? {
        get { super.textColor }
        set {
            super.textColor = newValue
            placeholderLabel.textColor = newValue
        }
    }
    
    var showFloatingPlaceholder: Bool = true
    
    private lazy var placeholderLabelSubView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 0.976, green: 0.976, blue: 0.976, alpha: 1)
        return view
    }()
    
    private lazy var placeholderLabel: PaddingLabel = {
        let label = PaddingLabel()
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = self.placeholder
        label.font = self.font?.withSize(10) ?? .systemFont(ofSize: 10)
        label.textColor = self.textColor ?? .black
        
        return label
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
       
        placeholderLabelSubView.heightAnchor.constraint(equalToConstant: placeholderLabel.frame.size.height / 2).isActive = true
    }
    
    private lazy var placeholderLabelTopAnchor: NSLayoutConstraint = {
        let top: NSLayoutConstraint = placeholderLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0)
        return top
    }()
    private func setUI() {
        self.textColor = .black
        self.font = .appfont(font: .medium, size: 14)
        self.textAlignment = .natural
        self.borderStyle = .roundedRect
        self.heightAnchor.constraint(equalToConstant: 48).isActive = true
        self.backgroundColor = UIColor(red: 0.976, green: 0.976, blue: 0.976, alpha: 1)

        self.addSubview(placeholderLabelSubView)
        self.addSubview(placeholderLabel)
        NSLayoutConstraint.activate([
            placeholderLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            placeholderLabelTopAnchor
        ])
        
        NSLayoutConstraint.activate([
            placeholderLabelSubView.leadingAnchor.constraint(equalTo: placeholderLabel.leadingAnchor),
            placeholderLabelSubView.trailingAnchor.constraint(equalTo: placeholderLabel.trailingAnchor),
            placeholderLabelSubView.bottomAnchor.constraint(equalTo: placeholderLabel.bottomAnchor),
        ])
        
        self.addTarget(self, action: #selector(didUserChangedText), for: .editingChanged)
        self.addTarget(self, action: #selector(didtextChanged), for: .editingChanged)
    }
    func verifyFields(){
        defer {
            var text = /self.text
            if text.hasPrefix(" ") || text.hasSuffix("  "){
                self.text = text.trimmingCharacters(in: .whitespaces)
            }
        }
        var characterSet: CharacterSet
        switch valueType {
        case .none:
            if let string = self.text {
                self.text = String(string.prefix(self.maxLength))
            }
            return
            
        case .onlyLetters:
            characterSet = CharacterSet.letters
            
        case .onlyNumbers:
            characterSet = CharacterSet.decimalDigits
            
        case .phoneNumber:
            characterSet = CharacterSet(charactersIn: "+0123456789")
            
        case .alphaNumeric:
            characterSet = CharacterSet.alphanumerics
            
        case .fullName:
            characterSet = CharacterSet.letters
            characterSet = characterSet.union(CharacterSet(charactersIn: " "))
            if !self.allowedCharInString.isEmpty {
                characterSet = CharacterSet(charactersIn: self.allowedCharInString)
            }
        case .email:
            characterSet = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ0123456789@._-")
        }
        self.text = self.text?.localisedNumber.trimmingCharacters(in: characterSet.inverted)
        if let string = self.text {
            self.text = String(string.prefix(self.maxLength))
        }
    }
    @objc private func didUserChangedText() {
        verifyFields()
        isError = false
    }
    @objc private func  didtextChanged() {
        placeholderLabel.textColor = self.textColor ?? .black
        self.setRoundRectColor(color: /text?.count < 1 ? UIColor(red: 0.962, green: 0.962, blue: 0.962, alpha: 1) : .lightGray)
        if self.placeholder?.count ?? 0 > 2 {
            UIView.animate(withDuration: 0.3) {
                if self.text?.isEmpty ?? true {
                    self.placeholderLabel.alpha = 0
                    self.placeholderLabelTopAnchor.constant = 0
                } else {
                    if self.showFloatingPlaceholder {
                        self.placeholderLabel.alpha = 1
                        self.placeholderLabelSubView.isHidden = false
                    } else {
                        self.placeholderLabelSubView.isHidden = true
                    }
                    self.placeholderLabelTopAnchor.constant = -24
                }
            }
        }
    }
    override var text: String? {
        didSet {
            didtextChanged()
        }
    }
    override var placeholder: String? {
        get { super.placeholder }
        set {
            super.placeholder = newValue
            placeholderLabel.text = newValue
            didtextChanged()
        }
    }
    var isError: Bool = false {
        didSet {
            
            self.placeholderLabel.textColor = isError ? .red : (self.textColor ?? .black)
            self.setRoundRectColor(color: isError ? .red : (UIColor(red: 0.962, green: 0.962, blue: 0.962, alpha: 1)))
            
            if isError{
                self.errorLabel.alpha = 1
                if self.placeholder?.count ?? 0 > 2 {
                    UIView.animate(withDuration: 0.3) {
                            self.placeholderLabel.alpha = 1
                            self.placeholderLabelTopAnchor.constant = -24
                    }
                }
            } else {
                self.errorLabel.alpha = 0
                didtextChanged()
            }
        }
    }
    //    MARK: - placeholder code ends
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.didtextChanged()
        }
    }
    
    override func deleteBackward() {
        super.deleteBackward()
        _ = self.delegate?.textField?(self, shouldChangeCharactersIn: NSRange(), replacementString: "")
    }
    
    private lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .red
        label.font = self.font?.withSize(10) ?? .systemFont(ofSize: 10)
        self.addSubview(label)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            label.topAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
            label.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
        ])
        return label
    }()
    var error: String? {
        didSet {
            self.errorLabel.text = error
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUI()
    }
    
    //    MARK: -  padding
    private var useableRightViewWidth: CGFloat {
        switch UIApplication.shared.userInterfaceLayoutDirection {
        case .leftToRight:
            return rightViewWidth
        case .rightToLeft:
            return leftViewWidth
        default:
            return rightViewWidth
        }
    }
    var leftViewWidth: CGFloat {
        self.leftView?.frame.width ?? 0
    }
    private var usableLeftViewWidth: CGFloat {
        switch UIApplication.shared.userInterfaceLayoutDirection {
        case .leftToRight:
            return leftViewWidth
        case .rightToLeft:
            return rightViewWidth
        default:
            return leftViewWidth
        }
    }
    func textFieldSpace(bounds: CGRect) -> CGRect {
        return CGRect(x: usableLeftViewWidth + 16, y: 0, width: bounds.width - (usableLeftViewWidth + useableRightViewWidth) - (32) , height: bounds.height)
    }
    
    @objc override func textRect(forBounds bounds: CGRect) -> CGRect {
        return super.textRect(forBounds: bounds).inset(by: .init(top: 0, left: 16, bottom: 0, right: 16))
    }
    
    @objc override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return super.placeholderRect(forBounds: bounds)
    }
    
    @objc override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return super.editingRect(forBounds: bounds).inset(by: .init(top: 0, left: 16, bottom: 0, right: 16))
    }
    
    lazy var rightViewWidth: CGFloat = {
        return 50
    }()
}
extension UITextField {
    func setRoundRectColor(color: UIColor?) {
        self.subviews.first?.layer.borderWidth = 0.5
        self.subviews.first?.layer.cornerRadius = 24
        self.subviews.first?.layer.borderColor = color?.cgColor ?? UIColor(red: 0.962, green: 0.962, blue: 0.962, alpha: 1).cgColor
    }
}

class PasswordTextField: AppPrimaryTextField {
    private lazy var toggleButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "eye.slash")?.withRenderingMode(.alwaysOriginal).withTintColor(Asset.ColorAssets.primaryColor1.color), for: .normal)
        button.contentEdgeInsets = .init(top: 0, left: 12, bottom: 0, right: 12)
        button.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
        return button
    }()
    
    @objc func togglePasswordVisibility() {
        isSecureTextEnabled.toggle()
        if isSecureTextEnabled {
            toggleButton.setImage(UIImage(systemName: "eye.slash")?.withRenderingMode(.alwaysOriginal).withTintColor(Asset.ColorAssets.primaryColor1.color), for: .normal)
        } else {
            toggleButton.setImage(UIImage(systemName: "eye")?.withRenderingMode(.alwaysOriginal).withTintColor(Asset.ColorAssets.primaryColor1.color), for: .normal)
        }
    }
    
    var isSecureTextEnabled: Bool = true {
        didSet { super.isSecureTextEntry = isSecureTextEnabled
            if isSecureTextEnabled {
                rightView = toggleButton
                rightViewMode = .always
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
