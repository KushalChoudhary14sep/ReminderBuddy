//
//  TaskDetailBottomView.swift
//  ReminderBuddy
//
//  Created by BigOh on 17/06/24.
//

import Foundation
import UIKit

protocol TaskDetailBottomViewDelegate: AnyObject {
    func didTapOnEditButton()
    func didTapOnDeleteButton()
}

class TaskDetailBottomView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            stackView.heightAnchor.constraint(equalToConstant: 44)
        ])
        self.backgroundColor = Asset.ColorAssets.primaryColor1.color
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    weak var delegate: TaskDetailBottomViewDelegate?
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [deleteButton, editButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        return stackView
    }()
    
    private lazy var editButton: PrimaryButton = {
        let button = PrimaryButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Edit", for: .normal)
        button.addAction(UIAction(handler: { [unowned self] _ in
            self.delegate?.didTapOnEditButton()
        }), for: .touchUpInside)
        button.tintColor = .white.withAlphaComponent(0.5)
        return button
    }()
    
    private lazy var deleteButton: PrimaryButton = {
        let button = PrimaryButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Delete", for: .normal)
        button.addAction(UIAction(handler: { [unowned self] _ in
            self.delegate?.didTapOnDeleteButton()
        }), for: .touchUpInside)
        button.tintColor = .red
        button.layer.borderColor = UIColor.red.cgColor
        return button
    }()
}
