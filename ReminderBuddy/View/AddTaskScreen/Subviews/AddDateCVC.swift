//
//  AddDateCVC.swift
//  ReminderBuddy
//
//  Created by Kushal Chaudhary on 16/06/24.
//

import Foundation
protocol AddDateCVCDelegate: AnyObject {
    func didSelectDate(date: Date)
}

import UIKit

class AddDateCell: UICollectionViewCell, DatePickerViewControllerDelegate {
    
    weak var delegate: AddDateCVCDelegate?
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.attributedText = NSAttributedString.setAttributedText(text: "Due Date", font: .appfont(font: .medium, size: 16), color: .white)
        return label
    }()
    
    lazy var dateTextField: AppPrimaryTextField = {
        let textField = AppPrimaryTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Choose Date"
        textField.valueType = .none
        textField.textContentType = .dateTime
        textField.keyboardType = .alphabet
        textField.showFloatingPlaceholder = false
        textField.maxLength = 60
        textField.addTarget(self, action: #selector(showDatePicker), for: .editingDidBegin)
        return textField
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
        contentView.addSubview(dateTextField)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            
            dateTextField.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            dateTextField.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            dateTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            dateTextField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
    
    @objc private func showDatePicker() {
        guard let parentViewController = parentViewController else { return }
        let datePickerVC = DatePickerViewController()
        datePickerVC.delegate = self
        datePickerVC.modalPresentationStyle = .overCurrentContext
        datePickerVC.modalTransitionStyle = .crossDissolve
        parentViewController.present(datePickerVC, animated: true, completion: nil)
        dateTextField.resignFirstResponder()
    }
    
    func didSelectDate(date: Date) {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM, yyyy"
        dateTextField.text = formatter.string(from: date)
        delegate?.didSelectDate(date: date)
    }
    
    func setDate(date: Date?) {
        if let date = date {
            let formatter = DateFormatter()
            formatter.dateFormat = "d MMMM, yyyy"
            dateTextField.text = formatter.string(from: date)
        }
    }
}


import UIKit

protocol DatePickerViewControllerDelegate: AnyObject {
    func didSelectDate(date: Date)
}

class DatePickerViewController: UIViewController {

    weak var delegate: DatePickerViewControllerDelegate?

    private let datePicker = UIDatePicker()
    private let stackView = UIStackView()
    
    private lazy var datePickerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black.withAlphaComponent(0.3)
        setupDatePicker()
        setupButtons()
    }

    private func setupDatePicker() {
        datePicker.backgroundColor = .white
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.minimumDate = Date()
        datePicker.maximumDate = Calendar.current.date(byAdding: .year, value: 50, to: Date())
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(datePickerView)
        NSLayoutConstraint.activate([
            datePickerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            datePickerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            datePickerView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        datePickerView.addSubview(datePicker)
        NSLayoutConstraint.activate([
            datePicker.leadingAnchor.constraint(equalTo: datePickerView.leadingAnchor, constant: 16),
            datePicker.trailingAnchor.constraint(equalTo: datePickerView.trailingAnchor, constant: -16),
            datePicker.topAnchor.constraint(equalTo: datePickerView.topAnchor, constant: 16),
            datePicker.heightAnchor.constraint(equalToConstant: 260)
        ])
    }

    private func setupButtons() {
        let doneButton = PrimaryButton()
        doneButton.setTitle("Done", for: .normal)
        doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)

        let cancelButton = SecondaryButton()
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        cancelButton.tintColor = .red
        cancelButton.layer.borderColor = UIColor.red.cgColor

        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false

        stackView.addArrangedSubview(cancelButton)
        stackView.addArrangedSubview(doneButton)

        datePickerView.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: datePicker.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: datePicker.trailingAnchor),

            stackView.bottomAnchor.constraint(equalTo: datePickerView.bottomAnchor, constant: -16),
            stackView.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    @objc private func doneButtonTapped() {
        delegate?.didSelectDate(date: datePicker.date)
        dismiss(animated: true, completion: nil)
    }

    @objc private func cancelButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
}
