//
//  TaskDetailTitleAndDescpCVC.swift
//  ReminderBuddy
//
//  Created by Kushal Choudahry on 17/06/24.
//

import UIKit

class TaskDetailTitleAndDescpCVC: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(dateLabel)
        NSLayoutConstraint.activate([
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            dateLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16)
        ])
        
        contentView.addSubview(statusLabel)
        NSLayoutConstraint.activate([
            statusLabel.leadingAnchor.constraint(lessThanOrEqualTo: dateLabel.trailingAnchor, constant: -12),
            statusLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            statusLabel.centerYAnchor.constraint(equalTo: dateLabel.centerYAnchor)
        ])
      
        contentView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            stackView.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -16),
            stackView.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 12)
        ])
        contentView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            titleLabel.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 16)
        ])
        
        contentView.addSubview(descriptionLabel)
        NSLayoutConstraint.activate([
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .appfont(font: .semiBold, size: 20)
        label.textColor = .white
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var statusLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .appfont(font: .semiBold, size: 16)
        label.textColor = .white
        label.numberOfLines = 1
        label.textAlignment = .right
        return label
    }()
    
    private lazy var locationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .appfont(font: .semiBold, size: 16)
        label.textColor = .white
        label.numberOfLines = 1
        label.textAlignment = .natural
        label.isHidden = true
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [locationLabel, priorityLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 12
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.axis = .vertical
        return stackView
    }()
    
    private lazy var flagImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var priorityLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .appfont(font: .semiBold, size: 16)
        label.numberOfLines = 1
        label.textAlignment = .natural
        return label
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .appfont(font: .semiBold, size: 18)
        label.textColor = .white
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .appfont(font: .medium, size: 16)
        label.textColor = .white.withAlphaComponent(0.9)
        label.numberOfLines = 0
        return label
    }()
    
    func setData(task: UserTask) {
        self.titleLabel.text = task.title
        self.descriptionLabel.text = task.description
        self.dateLabel.text = "\(task.dueDate.formatToDisplay())"
        self.setupPriority(task: task)
        self.setState(task: task)
        if let address = task.address {
            self.locationLabel.isHidden = false
            let attachemnt = NSTextAttachment(image: UIImage(systemName: "location.fill")!.withRenderingMode(.alwaysOriginal).withTintColor(.white))
            let mutableString = NSMutableAttributedString(attachment: attachemnt)
            mutableString.append(NSAttributedString(string: " \(address)"))
            self.locationLabel.attributedText = mutableString
        } else {
            self.locationLabel.isHidden = true
        }
    }
    
    func setState(task: UserTask) {
        let image = UIImage(systemName: "largecircle.fill.circle")!
        let attachemnt = NSTextAttachment()
        switch task.state {
        case .created:
            if Date() > task.dueDate {
                self.statusLabel.textColor = .systemRed
                attachemnt.image = image.withTintColor(.systemRed).withRenderingMode(.alwaysOriginal)
            } else {
                self.statusLabel.textColor = .systemBlue
                attachemnt.image = image.withTintColor(.systemBlue).withRenderingMode(.alwaysOriginal)
            }
        case .inProgress:
            if Date() > task.dueDate {
                self.statusLabel.textColor = .systemRed
                attachemnt.image = image.withTintColor(.systemRed).withRenderingMode(.alwaysOriginal)
            } else {
                self.statusLabel.textColor = .systemYellow
                attachemnt.image = image.withTintColor(.systemYellow).withRenderingMode(.alwaysOriginal)
            }
        case .completed:
            self.statusLabel.textColor = .systemGreen
            attachemnt.image = image.withTintColor(.systemGreen).withRenderingMode(.alwaysOriginal)
        }
        let mutableString = NSMutableAttributedString(attachment: attachemnt)
        mutableString.append(NSAttributedString(string: " \(task.state.rawValue)"))
        statusLabel.attributedText = mutableString
    }
    
    private func setupPriority(task: UserTask) {
        let attachement = NSTextAttachment()
        switch task.priority {
        case .low:
            priorityLabel.textColor = .systemBlue
            attachement.image = UIImage(systemName: "flag.fill")?.withTintColor(.systemBlue).withRenderingMode(.alwaysOriginal)
        case .medium:
            priorityLabel.textColor = .systemGreen
            attachement.image = UIImage(systemName: "flag.fill")?.withTintColor(.systemGreen).withRenderingMode(.alwaysOriginal)
        case .high:
            priorityLabel.textColor = .systemRed
            attachement.image = UIImage(systemName: "flag.fill")?.withTintColor(.systemRed).withRenderingMode(.alwaysOriginal)
        }
        let mutableString = NSMutableAttributedString(attachment: attachement)
        mutableString.append(NSAttributedString(string: " \(task.priority.rawValue)"))
        priorityLabel.attributedText = mutableString
    }
}
