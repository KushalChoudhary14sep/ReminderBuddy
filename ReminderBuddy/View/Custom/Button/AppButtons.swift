//
//  AppButtons.swift
//  ReminderBuddy
//
//  Created by Kaushal Chaudhary on 15/06/24.
//

import Foundation
import UIKit

class TextOnlyButton: UIButton {
    fileprivate var tint: UIColor = Asset.ColorAssets.primaryColor1.color
    override var tintColor: UIColor! {
        get { return  tint }
        set { tint = newValue }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.titleLabel?.font = .appfont(font: .semiBold, size: 12)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.titleLabel?.font = .appfont(font: .semiBold, size: 12)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        var color = tint
        if self.state == .normal {
             color = tint
        } else if state == .disabled {
            color = tint.withAlphaComponent(0.3)
        } else {
            color = tint.withAlphaComponent(0.7)
        }
        self.titleLabel?.textColor = color
        self.clipsToBounds = true
        self.addTarget(self, action: #selector(didtap), for: .touchUpInside)
    }
    @objc private func didtap() {
        HapticEngine.selectionChanged()
    }
}

class SecondaryButton: TextOnlyButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var color = tint
        if self.state == .normal {
             color = tint
        } else if state == .disabled {
            color = tint.withAlphaComponent(0.3)
        } else {
            color = tint.withAlphaComponent(0.7)
        }
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 4
        self.layer.borderColor = color.cgColor
    }
}
class PrimaryButton: TextOnlyButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        var color = tint
        if self.state == .normal {
             color = tint
        } else if state == .disabled {
            color = tint.withAlphaComponent(0.3)
        } else {
            color = tint.withAlphaComponent(0.7)
        }
        self.layer.cornerRadius = 12
        self.backgroundColor = color
        self.titleLabel?.textColor = .white
    }
}
