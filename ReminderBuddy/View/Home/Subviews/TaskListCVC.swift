//
//  TaskListCVC.swift
//  ReminderBuddy
//
//  Created by Kushal Chaudhary on 16/06/24.
//

import Foundation
import UIKit

class TaskListCVC: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var iconView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.appfont(font: .semiBold, size: 18)
        view.textColor = .black
        return view
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.appfont(font: .medium, size: 14)
        view.textColor = .darkText
        return view
    }()
    
    private lazy var dateLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.appfont(font: .regular, size: 14)
        view.textColor = .darkText
        view.setContentCompressionResistancePriority(.required, for: .horizontal)
        view.textAlignment = .right
        return view
    }()

    private lazy var priorityLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.appfont(font: .semiBold, size: 14)
        view.textColor = .darkText
        view.textAlignment = .right
        view.setContentCompressionResistancePriority(.required, for: .horizontal)
        return view
    }()
}

extension TaskListCVC {
    func setData(task: UserTask) {
        titleLabel.text = task.title.capitalized
        descriptionLabel.text = task.description
        dateLabel.text = task.dueDate.formatDateToString()
        setupPriority(task: task)
        setState(task: task)
    }
    
    func setState(task: UserTask) {
        switch task.state {
        case .created:
            if Date() > task.dueDate {
                self.iconView.backgroundColor = .systemRed
            } else {
                self.iconView.backgroundColor = .systemBlue
            }
        case .inProgress:
            if Date() > task.dueDate {
                self.iconView.backgroundColor = .systemRed
            } else {
                self.iconView.backgroundColor = .systemYellow
            }
        case .completed:
            self.iconView.backgroundColor = .systemGreen
        }
    }
}

private extension TaskListCVC {
    private func setupConstraints() {
        contentView.addSubview(iconView)
        NSLayoutConstraint.activate([
            iconView.heightAnchor.constraint(equalToConstant: 16),
            iconView.widthAnchor.constraint(equalTo: iconView.heightAnchor, multiplier: 1),
            iconView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            iconView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24)
        ])
        
        contentView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: iconView.centerYAnchor),
        ])
        
        contentView.addSubview(dateLabel)
        NSLayoutConstraint.activate([
            dateLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 16),
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            dateLabel.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor)
        ])
        
        contentView.addSubview(descriptionLabel)
        NSLayoutConstraint.activate([
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24)
        ])
        
        contentView.addSubview(priorityLabel)
        NSLayoutConstraint.activate([
            priorityLabel.leadingAnchor.constraint(greaterThanOrEqualTo: descriptionLabel.trailingAnchor, constant: 16),
            priorityLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            priorityLabel.centerYAnchor.constraint(equalTo: descriptionLabel.centerYAnchor)
        ])
    }
    
    private func setupUI() {
        iconView.layer.cornerRadius = 8
        layer.cornerRadius = 16
        layer.shadowRadius = 3
        layer.shadowOpacity = 1
        layer.shadowRadius = 16
        layer.shadowOffset = .init(width: 0, height: 2)
        layer.shadowColor = UIColor.white.withAlphaComponent(0.05).cgColor
        self.backgroundColor = .white
    }
    
    private func setupPriority(task: UserTask) {
        let attachement = NSTextAttachment()

        switch task.priority {
        case .low:
            attachement.image =  getFlagImage(color: .systemBlue)
        case .medium:
            attachement.image =  getFlagImage(color: .systemGreen)
        case .high:
            attachement.image =  getFlagImage(color: .red)
        }
        let mutableString = NSMutableAttributedString(attachment: attachement)
        mutableString.append(NSAttributedString(string: " \(task.priority.rawValue)"))
        priorityLabel.attributedText = mutableString
    }
    
    private func getFlagImage(color: UIColor) -> UIImage {
        return UIImage(systemName: "flag.fill")!.withTintColor(color).withRenderingMode(.alwaysOriginal)
    }
}
