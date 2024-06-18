//
//  AddStateCVC.swift
//  ReminderBuddy
//
//  Created by BigOh on 18/06/24.
//

import Foundation
import UIKit

protocol AddStateCVCDelegate: AnyObject {
    func didSelectState(state: UserTask.State)
}

import UIKit

class AddStateCell: UICollectionViewCell {
    
    weak var delegate: AddStateCVCDelegate?
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.attributedText = NSAttributedString.setAttributedText(text: "Mark Status", font: .appfont(font: .medium, size: 16), color: .white)
        return label
    }()
    
    let stateSelector: UISegmentedControl = {
        var items: [String] = []
        UserTask.State.allCases.forEach { priority in
            items.append(priority.rawValue)
        }
        let segmentedControl = UISegmentedControl(items: items)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.selectedSegmentIndex = 0
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
        segmentedControl.selectedSegmentTintColor = .white.withAlphaComponent(0.3)
        return segmentedControl
    }()
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
        self.backgroundColor = Asset.ColorAssets.primaryColor1.color
        self.layer.cornerRadius = 16
        self.addShadow(to: .all)
        stateSelector.addTarget(self, action: #selector(stateChanged(_:)), for: .valueChanged)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func stateChanged(_ sender: UISegmentedControl) {
          switch sender.selectedSegmentIndex {
          case 0:
              delegate?.didSelectState(state: .created)
              stateSelector.selectedSegmentTintColor = .systemBlue.withAlphaComponent(0.5)
          case 1:
              delegate?.didSelectState(state: .inProgress)
              stateSelector.selectedSegmentTintColor = .systemYellow.withAlphaComponent(0.5)
          case 2:
              delegate?.didSelectState(state: .completed)
              stateSelector.selectedSegmentTintColor = .systemGreen.withAlphaComponent(0.5)
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
        
        contentView.addSubview(stateSelector)
        NSLayoutConstraint.activate([
            stateSelector.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            stateSelector.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stateSelector.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stateSelector.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    func setState(task: UserTask?) {
        if let state = task?.state {
            switch state {
            case .created:
                stateSelector.selectedSegmentIndex = 0
                stateSelector.selectedSegmentTintColor = .systemBlue.withAlphaComponent(0.5)
            case .inProgress:
                stateSelector.selectedSegmentIndex = 1
                if let dueDate = task?.dueDate {
                    if Date() > dueDate {
                        stateSelector.selectedSegmentTintColor = .systemRed.withAlphaComponent(0.5)
                    } else {
                        stateSelector.selectedSegmentTintColor = .systemYellow.withAlphaComponent(0.5)
                    }
                } else {
                    stateSelector.selectedSegmentTintColor = .systemYellow.withAlphaComponent(0.5)
                }
            case .completed:
                stateSelector.selectedSegmentIndex = 2
                stateSelector.selectedSegmentTintColor = .systemGreen.withAlphaComponent(0.5)
            }
        }
    }
}
