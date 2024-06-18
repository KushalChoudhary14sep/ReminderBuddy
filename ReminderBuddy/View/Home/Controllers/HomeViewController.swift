//
//  HomeViewController.swift
//  ReminderBuddy
//
//  Created by Kaushal Chaudhary on 15/06/24.
//

import Foundation
import UIKit

protocol ListView: UIViewController {
    var collectionView: AppCollectionView { get }
    var appHeader: AppHeader { get }
}

protocol CommonView: ListView {
    var addTaskButton: FloatingAddTaskButton { get }
}

protocol HomeView: CommonView {
    var noTasksPlaceholder: TaskListPlacheholderView { get }
}

protocol CommonTaskListView: CommonView {
    var noTasksPlaceholder: TaskListPlacheholderView { get }
    var stackView: UIStackView { get }
}

class HomeViewController: UIViewController, CommonTaskListView {
    
    private let uiController = HomeUIController()
    
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
        let view = AppHeader(title: "Task Manager")
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
    
    override func loadView() {
        super.loadView()
        setupConstraints()
        view.backgroundColor = Asset.ColorAssets.primaryColor1.color
        uiController.view = self
    }
}

private extension HomeViewController {
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
