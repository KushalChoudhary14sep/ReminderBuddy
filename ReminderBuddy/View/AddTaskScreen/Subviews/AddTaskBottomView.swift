//
//  AddTaskBottomView.swift
//  ReminderBuddy
//
//  Created by Kushal Choudahry on 17/06/24.
//

import Foundation
import UIKit

protocol AddTaskBottomViewDelegate: AnyObject {
    func didTapOnSaveButton()
}

class AddTaskBottomView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(button)
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            button.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            button.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            button.heightAnchor.constraint(equalToConstant: 44)
        ])
        self.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    weak var delegate: AddTaskBottomViewDelegate?
    
    lazy var button: PrimaryButton = {
        let button = PrimaryButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Save", for: .normal)
        button.addAction(UIAction(handler: { [unowned self] _ in
            self.delegate?.didTapOnSaveButton()
        }), for: .touchUpInside)
        button.tintColor = UIColor.white.withAlphaComponent(0.5)
        return button
    }()
}
