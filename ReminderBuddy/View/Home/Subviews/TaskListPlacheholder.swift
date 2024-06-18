//
//  TaskListPlacheholder.swift
//  ReminderBuddy
//
//  Created by Kushal Chaudhary on 16/06/24.
//

import Foundation
import UIKit

class TaskListPlacheholderView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
        self.backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(image: Asset.Assets.homeTasklistPlaceholder.image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.attributedText = NSAttributedString.setAttributedText(text: Local.Home.TaskList.placeholder, font: .appfont(font: .medium, size: 14), color: Asset.ColorAssets.primaryColor1.color)
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.attributedText = NSAttributedString.setAttributedText(text: "Welcome \(/UserManager.shared.currentUser?.firstName)!", font: .appfont(font: .bold, size: 24), color: Asset.ColorAssets.primaryColor1.color)
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()
    
    private func setupConstraints() {
        addSubview(userNameLabel)
        NSLayoutConstraint.activate([
            userNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 64),
            userNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -64),
            userNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 60)
        ])
        
        
        
        addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: 200),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: 1),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -80)
        ])
        
        addSubview(placeholderLabel)
        NSLayoutConstraint.activate([
            placeholderLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 64),
            placeholderLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -64),
            placeholderLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16)
        ])
    }
}
