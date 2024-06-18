//
//  SplashImageView.swift
//  ReminderBuddy
//
//  Created by Kushal Chaudhary on 15/06/24.
//

import Foundation
import UIKit

final class SplashImageView: UIView {
    
    // MARK: UI Elements
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(image: Asset.Assets.splash.image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // MARK: Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startAnimation(completion: @escaping () -> Void) {
        self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        imageView.alpha = 0.0
        UIView.animate(withDuration: 2.0, delay: 0.0, options: .curveEaseInOut, animations: {
            self.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            self.imageView.alpha = 1.0
        }) { (finished) in
            UIView.animate(withDuration: 2.0, delay: 0.0, options: .curveEaseInOut, animations: {
                self.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                self.imageView.alpha = 0.0
            }) { (finished) in
                self.removeFromSuperview()
                completion()
            }
        }
    }
}

private extension SplashImageView {
    private func setupConstraints() {
        addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

