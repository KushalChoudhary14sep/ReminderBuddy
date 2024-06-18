//
//  DashboardUIController.swift
//  ReminderBuddy
//
//  Created by Kaushal Chaudhary on 15/06/24.
//

import Foundation
import UIKit

class DashboardUIController {
    weak var view: CommonTaskListView? {
        didSet {
            guard let view = view else { return }
            configure(view: view)
        }
    }
    
    private let viewModel = DashboardViewModel()
    
    private func configure(view: CommonTaskListView) {
        view.addTaskButton.delegate = self
        configureUI(view: view)
        view.collectionView.registerCells([
            DashboardTaskStatusCell.self
        ])
        view.collectionView.refreshControl?.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        view.collectionView.dataSource = datasource
        view.collectionView.contentInset = .init(top: 0, left: 0, bottom: 72, right: 0)
    }
    
    private lazy var datasource: DashboardDatasoucre = {
        let datasource = DashboardDatasoucre(viewModel: viewModel)
        return datasource
    }()
    
    @objc func didPullToRefresh() {
        view?.collectionView.reloadData()
        view?.collectionView.refreshControl?.endRefreshing()
    }
    
    func viewWillAppear() {
        didPullToRefresh()
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


extension DashboardUIController: FloatingAddTaskButtonDelegate {
    func didTapOnAddTaskButton() {
        AppNavigationDelegate.shared.didTapOnAddTaskButton(delegate: self)
    }
}

extension DashboardUIController: AddTaskViewModelDelegates {
    func didAddTask() {
        guard let view = view else { return }
        configureUI(view: view)
    }
}
