//
//  DashboardViewController.swift
//  ReminderBuddy
//
//  Created by Kaushal Chaudhary on 15/06/24.
//

import Foundation
import UIKit

class DashboardViewController: UIViewController, CommonTaskListView {
    lazy var collectionView: AppCollectionView = {
        let collectionView = AppCollectionView(frame: .zero, collectionViewLayout: uiController.collectionViewLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.allowPullToRefresh = true
        collectionView.isHeightExpandable = false
        return collectionView
    }()
    
    lazy var addTaskButton: FloatingAddTaskButton = {
        let button = FloatingAddTaskButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var appHeader: AppHeader = {
        let view = AppHeader(title: "Dashboard")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var noTasksPlaceholder: TaskListPlacheholderView = {
        let view = TaskListPlacheholderView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [collectionView, noTasksPlaceholder])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let uiController = DashboardUIController()
    
    override func loadView() {
        super.loadView()
        setupConstraints()
        view.backgroundColor = Asset.ColorAssets.primaryColor1.color
        uiController.view = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        uiController.viewWillAppear()
    }
}

private extension DashboardViewController {
    private func setupConstraints() {
        view.addSubview(appHeader)
        NSLayoutConstraint.activate([
            appHeader.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            appHeader.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            appHeader.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),

        ])
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: appHeader.bottomAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        view.addSubview(addTaskButton)
        NSLayoutConstraint.activate([
            addTaskButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            addTaskButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            addTaskButton.heightAnchor.constraint(equalToConstant: 56),
            addTaskButton.widthAnchor.constraint(equalTo: addTaskButton.heightAnchor, multiplier: 1)
        ])
        view.bringSubviewToFront(addTaskButton)
    }
}
