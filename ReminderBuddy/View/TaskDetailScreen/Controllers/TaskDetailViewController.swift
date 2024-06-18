//
//  TaskDetailViewController.swift
//  ReminderBuddy
//
//  Created by Kushal Chaudhary on 16/06/24.
//

import Foundation
import UIKit

protocol TaskDetailView: ListView {
    var bottomView: TaskDetailBottomView { get }
}

class TaskDetailViewController: UIViewController, TaskDetailView {
    lazy var collectionView: AppCollectionView = {
        let collectionView = AppCollectionView(frame: .zero, collectionViewLayout: uiController.collectionViewLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isHeightExpandable = false
        return collectionView
    }()
    
    lazy var appHeader: AppHeader = {
        let view = AppHeader(title: "Task Details", showBackButton: true)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var bottomView: TaskDetailBottomView = {
        let view = TaskDetailBottomView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let uiController = TaskDetailUIController()
    
    override func loadView() {
        super.loadView()
        setupConstraints()
        self.navigationController?.navigationBar.isHidden = true
        uiController.view = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        uiController.viewWillDisappear()
    }
}

private extension TaskDetailViewController {
    private func setupConstraints() {
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
        ])
        
        view.addSubview(bottomView)
        NSLayoutConstraint.activate([
            collectionView.bottomAnchor.constraint(equalTo: bottomView.topAnchor),
            bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            bottomView.heightAnchor.constraint(equalToConstant: 68)
        ])
    }
}
