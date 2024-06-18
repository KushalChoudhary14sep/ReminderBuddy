//
//  SettingsViewController.swift
//  ReminderBuddy
//
//  Created by Kushal Chaudhary on 15/06/24.
//

import Foundation
import UIKit

class SettingsViewController: UIViewController, CommonView {
    lazy var collectionView: AppCollectionView = {
        let collectionView = AppCollectionView(frame: .zero, collectionViewLayout: .init())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.allowPullToRefresh = true
        collectionView.isHeightExpandable = false
        collectionView.isHidden = true
        return collectionView
    }()
    
    lazy var biometricSwitch: UISwitch = {
        let biometricSwitch = UISwitch()
        biometricSwitch.translatesAutoresizingMaskIntoConstraints = false
        biometricSwitch.isOn = UserManager.shared.isBiometricAuthenticationEnabled()
        biometricSwitch.addTarget(self, action: #selector(biometricSwitchToggled), for: .valueChanged)
        return biometricSwitch
    }()
    
    lazy var biometricLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.attributedText = NSAttributedString.setAttributedText(text: "Turn on Face ID", font: .appfont(font: .medium, size: 14), color: .white)
        return label
    }()
    
    @objc func biometricSwitchToggled(_ sender: UISwitch) {
        UserManager.shared.enableBiometricAuthentication(enabled: sender.isOn)
    }
    
    lazy var addTaskButton: FloatingAddTaskButton = {
        let button = FloatingAddTaskButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var appHeader: AppHeader = {
        let view = AppHeader(title: "Settings")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var logoutButton: SecondaryButton = {
        let cancelButton = SecondaryButton()
        cancelButton.setTitle("Logout", for: .normal)
        cancelButton.tintColor = .red
        cancelButton.layer.borderColor = UIColor.red.cgColor
        cancelButton.addAction(UIAction(handler: { [unowned self] _ in
            cancelButton.loadingIndicator(true)
            UserManager.shared.removeUser {
                AppNavigationDelegate.shared.gotoRoot()
            }
        }), for: .touchUpInside)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        return cancelButton
    }()
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = Asset.ColorAssets.primaryColor1.color
        view.addSubview(appHeader)
        NSLayoutConstraint.activate([
            appHeader.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            appHeader.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            appHeader.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
        ])
        
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: appHeader.bottomAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        view.addSubview(addTaskButton)
        NSLayoutConstraint.activate([
            addTaskButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            addTaskButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            addTaskButton.heightAnchor.constraint(equalToConstant: 56),
            addTaskButton.widthAnchor.constraint(equalTo: addTaskButton.heightAnchor, multiplier: 1)
        ])
        view.bringSubviewToFront(addTaskButton)
        
        view.addSubview(logoutButton)
        NSLayoutConstraint.activate([
            logoutButton.heightAnchor.constraint(equalToConstant: 44),
            logoutButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            logoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            logoutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoutButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        view.bringSubviewToFront(logoutButton)
        view.addSubview(biometricLabel)
        NSLayoutConstraint.activate([
            biometricLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            biometricLabel.topAnchor.constraint(equalTo: logoutButton.bottomAnchor, constant: 20)
        ])
        view.addSubview(biometricSwitch)
        NSLayoutConstraint.activate([
            biometricSwitch.centerYAnchor.constraint(equalTo: biometricLabel.centerYAnchor),
            biometricSwitch.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            biometricSwitch.leadingAnchor.constraint(equalTo: biometricLabel.trailingAnchor, constant: -16)
        ])
    }
}
