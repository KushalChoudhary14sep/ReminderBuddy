//
//  UIPlaceholderTextView.swift
//  ReminderBuddy
//
//  Created by Kushal Chaudhary on 16/06/24.
//

import Foundation
import UIKit

class UIPlaceholderTextView: UITextView {
    
    private var placeholderLabel: UILabel = UILabel()
    var minimumHeight: CGFloat = 17

    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        sharedInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        sharedInit()
    }
    
    private func sharedInit() {
        NotificationCenter.default.addObserver(self, selector: #selector(textChanged), name: UITextView.textDidChangeNotification, object: self)
        self.contentInset = .init(top: 8, left: 8, bottom: 8, right: 8)
        self.textAlignment = .natural
        configurePlaceholderLabel()
        refreshPlaceholder()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UITextView.textDidChangeNotification, object: self)
    }
    
    var placeholder: String? {
        didSet {
            refreshPlaceholder()
        }
    }
    
    private func configurePlaceholderLabel() {
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        placeholderLabel.textColor = .lightGray
        placeholderLabel.font = .systemFont(ofSize: 12)
        placeholderLabel.numberOfLines = 0
        addSubview(placeholderLabel)
        
        NSLayoutConstraint.activate([
            placeholderLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            placeholderLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
            placeholderLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 8)
        ])
    }
    
    private func refreshPlaceholder() {
        placeholderLabel.text = placeholder
        placeholderLabel.isHidden = !text.isEmpty
    }
    
    @objc private func textChanged() {
        refreshPlaceholder()
        setNeedsLayout()
    }
    
    override var text: String! {
        didSet {
            textChanged()
        }
    }
    
    private lazy var heightConstraint: NSLayoutConstraint = {
        let constraint = self.heightAnchor.constraint(equalToConstant: minimumHeight)
        constraint.isActive = true
        return constraint
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let newContentSize = self.sizeThatFits(CGSize(width: self.frame.width, height: CGFloat.greatestFiniteMagnitude))
        let newHeight = max(newContentSize.height, minimumHeight)
        if heightConstraint.constant != newHeight {
            heightConstraint.constant = newHeight
        }
    }
}
