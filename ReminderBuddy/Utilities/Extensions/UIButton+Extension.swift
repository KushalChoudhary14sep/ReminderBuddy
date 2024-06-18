//
//  UIButton+Extension.swift
//  ReminderBuddy
//
//  Created by Kaushal Chaudhary on 15/06/24.
//

import Foundation
import UIKit

extension UIButton {
    @objc func loadingIndicator(_ show: Bool) {
        let tag = 808404
        if show {
            self.isEnabled = false
            self.alpha = 0.5
            let indicator = UIActivityIndicatorView()
            indicator.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(indicator)
            NSLayoutConstraint.activate([
                indicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                indicator.centerYAnchor.constraint(equalTo: self.centerYAnchor)
            ])
            indicator.tag = tag
            indicator.startAnimating()
        } else {
            self.isEnabled = true
            self.alpha = 1.0
            self.subviews.forEach({
                if $0.tag == tag {
                    $0.removeFromSuperview()
                }
            })
            if let indicator = self.viewWithTag(tag) as? UIActivityIndicatorView {
                indicator.stopAnimating()
                indicator.removeFromSuperview()
            }
        }
    }
}
