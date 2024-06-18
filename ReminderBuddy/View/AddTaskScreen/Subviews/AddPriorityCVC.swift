//
//  AddPriorityCVC.swift
//  ReminderBuddy
//
//  Created by Kushal Choudahry on 17/06/24.
//

import Foundation
import UIKit

protocol AddPriorityCVCDelegate: AnyObject {
    func didSelectPriority(priority: UserTask.Priority)
}

import UIKit

class AddPriorityCell: UICollectionViewCell {
    
    weak var delegate: AddPriorityCVCDelegate?
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.attributedText = NSAttributedString.setAttributedText(text: "Priority", font: .appfont(font: .medium, size: 16), color: .white)
        return label
    }()
    
    let prioritySelector: UISegmentedControl = {
        var items: [String] = []
        UserTask.Priority.allCases.forEach { priority in
            items.append(priority.rawValue)
        }
        let segmentedControl = UISegmentedControl(items: items)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.selectedSegmentIndex = 1
        segmentedControl.selectedSegmentTintColor = .systemGreen.withAlphaComponent(0.5)
        // Set normal state attributes
        let normalAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.lightText
        ]
        segmentedControl.setTitleTextAttributes(normalAttributes, for: .normal)
        
        // Set selected state attributes
        let selectedAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white
        ]
        segmentedControl.setTitleTextAttributes(selectedAttributes, for: .selected)
        
        // Set background colors
        segmentedControl.backgroundColor = Asset.ColorAssets.primaryColor1.color
        return segmentedControl
    }()
        
    private func setFlagImage(imageView: UIImageView, color: UIColor) {
        imageView.image = UIImage(systemName: "flag.fill")?.withTintColor(color).withRenderingMode(.alwaysTemplate)
    }
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
        self.backgroundColor = Asset.ColorAssets.primaryColor1.color
        self.layer.cornerRadius = 16
        self.addShadow(to: .all)
        prioritySelector.addTarget(self, action: #selector(priorityChanged(_:)), for: .valueChanged)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func priorityChanged(_ sender: UISegmentedControl) {
          switch sender.selectedSegmentIndex {
          case 0:
              delegate?.didSelectPriority(priority: .low)
              prioritySelector.selectedSegmentTintColor = .systemBlue.withAlphaComponent(0.5)
          case 1:
              delegate?.didSelectPriority(priority: .medium)
            prioritySelector.selectedSegmentTintColor = .systemGreen.withAlphaComponent(0.5)
          case 2:
              delegate?.didSelectPriority(priority: .high)
              prioritySelector.selectedSegmentTintColor = .systemRed.withAlphaComponent(0.5)
          default:
              break
          }
      }
    
    private func setupConstraints() {
        contentView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            
        ])
        
        contentView.addSubview(prioritySelector)
        NSLayoutConstraint.activate([
            prioritySelector.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            prioritySelector.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            prioritySelector.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            prioritySelector.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    func setPriority(priority: UserTask.Priority?) {
        if let priority = priority {
            switch priority {
            case .low:
                prioritySelector.selectedSegmentIndex = 0
            case .medium:
                prioritySelector.selectedSegmentIndex = 1
            case .high:
                prioritySelector.selectedSegmentIndex = 2
            }
        }
    }
}
