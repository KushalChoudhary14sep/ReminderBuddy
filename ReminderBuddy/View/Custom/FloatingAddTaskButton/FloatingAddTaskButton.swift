//
//  FloatingAddTaskButton.swift
//  ReminderBuddy
//
//  Created by Kushal Chaudhary on 16/06/24.
//

import Foundation
import UIKit

protocol FloatingAddTaskButtonDelegate: AnyObject {
    func didTapOnAddTaskButton()
}

class FloatingAddTaskButton: UIButton {
    
    weak var delegate: FloatingAddTaskButtonDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 56 / 2
        self.backgroundColor = .white
        self.tintColor = Asset.ColorAssets.primaryColor1.color
        self.setImage(UIImage(systemName: "plus"), for: .normal)
        self.addAction(UIAction(handler: { [unowned self] _ in
            self.delegate?.didTapOnAddTaskButton()
        }), for: .touchUpInside)
        self.layer.borderWidth = 1
        self.layer.borderColor = Asset.ColorAssets.primaryColor1.color.cgColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

