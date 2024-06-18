//
//  SplashUIController.swift
//  ReminderBuddy
//
//  Created by Kaushal Chaudhary on 15/06/24.
//

import Foundation
import UIKit

final class SplashUIController {
    weak var view: SplashView? {
        didSet {
            guard let view = view else { return }
            configure(view: view)
        }
    }
    
    private func configure(view: SplashView) {
        setupUI(view: view)
        animateSplashView(view: view)
    }
}

private extension SplashUIController {
    private func setupUI(view: SplashView) {
        view.navigationController?.setNavigationBarHidden(true, animated: false)
        view.view.backgroundColor = Asset.ColorAssets.primaryColor1.color
    }
    
    private func animateSplashView(view: SplashView) {
        view.splashView.startAnimation {
            AppNavigationDelegate.shared.start()
        }
    }
}
