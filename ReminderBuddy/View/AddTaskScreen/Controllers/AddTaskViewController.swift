//
//  AddTaskViewController.swift
//  ReminderBuddy
//
//  Created by Kushal Chaudhary on 16/06/24.
//

import Foundation
import UIKit

protocol AddTaskView: ListView {
    var saveButtonView: AddTaskBottomView { get }
}

class AddTaskViewController: UIViewController, AddTaskView {    
    
    let uiController = AddTaskUIController()
    
    lazy var collectionView: AppCollectionView = {
        let collectionView = AppCollectionView(frame: .zero, collectionViewLayout: uiController.collectionViewLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isHeightExpandable = false
        collectionView.backgroundColor = Asset.ColorAssets.primaryColor1.color
        collectionView.minimumHeight = 54
        return collectionView
    }()
    
    lazy var appHeader: AppHeader = {
        let view = AppHeader(title: /uiController.viewModel.taskConfigurationType?.rawValue, showBackButton: true)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var saveButtonView: AddTaskBottomView = {
        let view = AddTaskBottomView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func loadView() {
        super.loadView()
        uiController.view = self
        setupConstraints()
        view.backgroundColor = Asset.ColorAssets.primaryColor1.color
    }
}

private extension AddTaskViewController {
    private func setupConstraints() {
        view.addSubview(appHeader)
        NSLayoutConstraint.activate([
            appHeader.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            appHeader.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            appHeader.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])

        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: appHeader.bottomAnchor)
        ])

        view.addSubview(saveButtonView)
        NSLayoutConstraint.activate([
            collectionView.bottomAnchor.constraint(equalTo: saveButtonView.topAnchor),
            saveButtonView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            saveButtonView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            saveButtonView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            saveButtonView.heightAnchor.constraint(equalToConstant: 68) // Set a fixed height for saveButtonView
        ])
    }
}
