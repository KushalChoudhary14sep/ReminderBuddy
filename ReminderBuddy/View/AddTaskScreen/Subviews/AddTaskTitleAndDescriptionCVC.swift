//
//  AddTaskTitleAndDescriptionCVC.swift
//  ReminderBuddy
//
//  Created by Kaushal Chaudhary on 16/06/24.
//

import Foundation
import UIKit

enum DetailType {
    case title(newString: String)
    case description(newString: String)
}

protocol AddTaskTitleAndDescriptionCVCDelegate: AnyObject {
    func didDetailChange(for detailType: DetailType)
}

class AddTaskTitleAndDescriptionCVC: UICollectionViewCell {
    weak var delegate: AddTaskTitleAndDescriptionCVCDelegate?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        titleTextField.text = nil
    }
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.attributedText = NSAttributedString.setAttributedText(text: "Title", font: .appfont(font: .medium, size: 16), color: .white)
        return label
    }()
    
    lazy var titleTextField: AppPrimaryTextField = {
        let textField = AppPrimaryTextField()
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Title"
        textField.showFloatingPlaceholder = false
        textField.valueType = .none
        textField.textContentType = .name
        textField.keyboardType = .alphabet
        textField.maxLength = 60
        return textField
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.attributedText = NSAttributedString.setAttributedText(text: "Description", font: .appfont(font: .medium, size: 16), color: .white)
        return label
    }()
    
    lazy var detailTextView: UIPlaceholderTextView = {
        let textView = UIPlaceholderTextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.delegate = self
        textView.minimumHeight = 150
        textView.layer.borderWidth = 0.5
        textView.layer.borderColor = UIColor(red: 0.962, green: 0.962, blue: 0.962, alpha: 1).cgColor
        textView.layer.cornerRadius = 16
        textView.backgroundColor = UIColor(red: 0.976, green: 0.976, blue: 0.976, alpha: 1)
        textView.isEditable = true
        textView.placeholder = "Description"
        textView.font = .systemFont(ofSize: 12, weight: .semibold) // Example font
        textView.textColor = .black
        return textView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
        self.backgroundColor = Asset.ColorAssets.primaryColor1.color
        self.layer.cornerRadius = 16
        self.addShadow(to: .all)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        contentView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16)
        ])
        contentView.addSubview(titleTextField)
        NSLayoutConstraint.activate([
            titleTextField.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            titleTextField.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            titleTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12)
        ])
        contentView.addSubview(descriptionLabel)
        NSLayoutConstraint.activate([
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 20)
        ])
        contentView.addSubview(detailTextView)
        NSLayoutConstraint.activate([
            detailTextView.leadingAnchor.constraint(equalTo: titleTextField.leadingAnchor),
            detailTextView.trailingAnchor.constraint(equalTo: titleTextField.trailingAnchor),
            detailTextView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 12),
            detailTextView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            detailTextView.heightAnchor.constraint(equalToConstant: 150)
        ])
    }
    
    func setTitle(title: String?, description: String?) {
        if let title = title {
            titleTextField.text = title
        }
        
        if let description = description {
            detailTextView.text = description
        }
    }
}

extension AddTaskTitleAndDescriptionCVC: UITextFieldDelegate, UITextViewDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textField {
        case titleTextField:
            let currentString: NSString = (textField.text ?? "") as NSString
            let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
            delegate?.didDetailChange(for: .title(newString: newString as String))
        default:
            break;
        }
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        delegate?.didDetailChange(for: .description(newString: textView.text))
        textView.layer.borderColor = textView.text.count < 1 ? UIColor(red: 0.962, green: 0.962, blue: 0.962, alpha: 1).cgColor : UIColor.lightGray.cgColor
    }
}
