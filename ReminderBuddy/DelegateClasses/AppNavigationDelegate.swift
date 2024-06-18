//
//  File.swift
//  ReminderBuddy
//
//  Created by Kushal Chaudhary on 15/06/24.
//

import Foundation
import UIKit

// MARK: - App Navigation Delegate
/// A singleton class responsible for managing the application's navigation stack and `UINavigationController`.
/// Use this class to control the app's navigation flow and maintain the navigation stack.
final class AppNavigationDelegate: NSObject  {
    
    private override init() {
        super.init()
    }
    var navigationController = UINavigationController()
    var window: UIWindow?
    
    static var shared = AppNavigationDelegate()
    
}

// MARK: - AppNavigationDelegate - UIApplicationDelegate
/// Configures the initial setup of the application's navigation stack and root view controller.
extension AppNavigationDelegate: UIApplicationDelegate {
    
    @discardableResult func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let navigation = navigationController
        navigation.setViewControllers([SplashViewController()], animated: true)
        navigation.isNavigationBarHidden = true
        navigation.view.backgroundColor = Asset.ColorAssets.primaryColor1.color
        window = UIWindow()
        window?.backgroundColor = .white
        window?.rootViewController = navigation
        window?.makeKeyAndVisible()
        CalendarManager.shared.requestCalendarAccess()
        return true
    }
}

extension AppNavigationDelegate {
    func start() {
        if UserManager.shared.isBiometricAuthenticationEnabled() {
            UserManager.shared.authenticateUser {[weak self] success, error in
                guard let self = self else { return }
                if success {
                    self.gotoRoot()
                } else {
                    UserManager.shared.removeUser {
                        self.gotoRoot()
                    }
                }
            }
        } else {
            gotoRoot()
        }
    }
    func gotoRoot() {
        if UserManager.shared.currentUser != nil {
            showTabBar(for: self.navigationController)
        } else {
            showEnrollemnt(for: self.navigationController)
        }
    }
    
    func showTabBar(for navigationController: UINavigationController) {
        let initial = TabBarController()
        navigationController.pushViewController(initial, animated: false)
        navigationController.viewControllers = [initial]
    }
    
    func showEnrollemnt(for navigationController: UINavigationController) {
        let viewController = LoginViewController()
        navigationController.pushViewController(viewController, animated: true)
        navigationController.viewControllers = [viewController]
    }
    
    func didTapOnAddTaskButton(delegate: AddTaskViewModelDelegates) {
        let viewController = AddTaskViewController()
        viewController.uiController.viewModel.taskConfigurationType = .add
        viewController.uiController.delegate = delegate
        let rootVC = UINavigationController(rootViewController: viewController)
        rootVC.navigationBar.isHidden = true
        rootVC.modalPresentationStyle = .overFullScreen
        navigationController.present(rootVC, animated: true)
    }
}
