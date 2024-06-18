//
//  SplashViewController.swift
//  ReminderBuddy
//
//  Created by Kushal Chaudhary on 15/06/24.
//

import Foundation
import UIKit

protocol SplashView: UIViewController {
    var splashView: SplashImageView { get }
}

final class SplashViewController: UIViewController, SplashView {
    
    private let uiController = SplashUIController()
    
    lazy var splashView: SplashImageView = {
        let view = SplashImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func loadView() {
        super.loadView()
        uiController.view = self
        setupConstraints()
    }
}

private extension SplashViewController {
    private func setupConstraints() {
        view.addSubview(splashView)
        NSLayoutConstraint.activate([
            splashView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            splashView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            splashView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}
