//
//  HomeUIController.swift
//  ReminderBuddy
//
//  Created by Kushal Chaudhary on 15/06/24.
//

import Foundation
import UIKit

class HomeUIController {
    weak var view: CommonTaskListView? {
        didSet {
            guard let view = view else { return }
            configure(view: view)
        }
    }
    
    private lazy var datasource: HomeDataSource = {
        let datasource = HomeDataSource(viewModel: viewModel)
        datasource.delegate = self
        return datasource
    }()
    
    private let viewModel = HomeViewModel()
    
    private func configure(view: CommonTaskListView) {
        view.addTaskButton.delegate = self
        configureUI(view: view)
        view.collectionView.registerCells([
            TaskListCVC.self
        ])
        view.collectionView.refreshControl?.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        view.collectionView.dataSource = datasource
        view.collectionView.delegate = datasource
        view.collectionView.contentInset = .init(top: 0, left: 0, bottom: 72, right: 0)
    }
    
    @objc func didPullToRefresh() {
        view?.collectionView.reloadData()
        view?.collectionView.refreshControl?.endRefreshing()
    }
    
    func configureUI(view: CommonTaskListView) {
        if viewModel.tasks.isEmpty {
            view.noTasksPlaceholder.isHidden = false
            view.collectionView.isHidden = true
        } else {
            view.noTasksPlaceholder.isHidden = true
            view.collectionView.isHidden = false
        }
        view.collectionView.reloadData()
    }
    
    func collectionViewLayout() -> UICollectionViewLayout {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(180)))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(180)), subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 16, leading: 16, bottom: 16, trailing: 16)
        section.interGroupSpacing = 16
        return UICollectionViewCompositionalLayout(section: section)
    }
}

extension HomeUIController: HomeDelegate {
    func didSelectTask(task: UserTask) {
        guard let view = view else { return }
        let viewController = TaskDetailViewController()
        viewController.uiController.viewmodel.task = task
        viewController.uiController.delegate = self
        AppNavigationDelegate.shared.navigationController.pushViewController(viewController, animated: true)
    }
}

extension HomeUIController: FloatingAddTaskButtonDelegate {
    func didTapOnAddTaskButton() {
        AppNavigationDelegate.shared.didTapOnAddTaskButton(delegate: self)
    }
}

extension HomeUIController: AddTaskViewModelDelegates {
    func didAddTask() {
        guard let view = view else { return }
        configureUI(view: view)
    }
}
extension HomeUIController: TaskDetailViewModelDelegates {
    func didDeleteTask() {
        guard let view = view else { return }
        configureUI(view: view)
    }
}
