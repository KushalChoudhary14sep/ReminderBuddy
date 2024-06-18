//
//  AppHeader.swift
//  ReminderBuddy
//
//  Created by Kushal Chaudhary on 16/06/24.
//

import Foundation
import UIKit

class AppHeader: UIView {
    
    init(title: String, showBackButton: Bool? = false) {
        super.init(frame: .zero)
        titleLabel.attributedText = NSAttributedString.setAttributedText(text: title, font: .appfont(font: .extraBold, size: 26), color: .white)
        self.backgroundColor = Asset.ColorAssets.primaryColor1.color
        self.heightAnchor.constraint(equalToConstant: 52).isActive = true
        
        addSubview(titleLabel)
        if /showBackButton {
            addSubview(backButton)
            NSLayoutConstraint.activate([
                backButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
                backButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
            ])
        }
        
        if /showBackButton {
            NSLayoutConstraint.activate([
                titleLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
                titleLabel.leadingAnchor.constraint(equalTo: backButton.trailingAnchor, constant: 16),
            ])
        } else {
            NSLayoutConstraint.activate([
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            titleLabel.leadingAnchor.constraint(lessThanOrEqualTo: leadingAnchor, constant: 16)
            ])
        }
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
        
       
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var backButton: UIButton = {
        let backButton = UIButton()
        backButton.heightAnchor.constraint(equalToConstant: 32).isActive = true
        backButton.widthAnchor.constraint(equalTo: backButton.heightAnchor, multiplier: 1).isActive = true
        backButton.layer.cornerRadius = 6
        backButton.backgroundColor = .white
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        backButton.tintColor = Asset.ColorAssets.primaryColor1.color
        backButton.addAction(.init(handler: { [weak self] _ in
            guard let self = self else { return }
            if let parent = self.parentViewController {
                if /parent.navigationController?.viewControllers.count > 1 {
                    self.parentViewController?.navigationController?.popViewController(animated: true)
                } else {
                    self.parentViewController?.navigationController?.dismiss(animated: true)
                    self.parentViewController?.dismiss(animated: true)
                }
            }
        }), for: .touchUpInside)
        return backButton
    }()
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textAlignment = .center
        return titleLabel
    }()
}
