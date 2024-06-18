//
//  TaskDetailUIController.swift
//  ReminderBuddy
//
//  Created by Kaushal Chaudhary on 16/06/24.
//

import Foundation
import UIKit

class TaskDetailUIController {
    
    weak var view: TaskDetailView? {
        didSet {
            guard let view = view else { return }
            viewmodel.delegate = self
            configure(view: view)
            view.collectionView.backgroundColor = Asset.ColorAssets.primaryColor1.color
            view.view.backgroundColor = Asset.ColorAssets.primaryColor1.color
        }
    }
    
    let viewmodel = TaskDetailViewModel()
    
    weak var delegate: TaskDetailViewModelDelegates?
    
    private lazy var datasource: TaskDetailDataosurce = {
        let datasource = TaskDetailDataosurce(viewModel: viewmodel)
        return datasource
    }()
    
    private func configure(view: TaskDetailView) {
        view.bottomView.delegate = self
        view.collectionView.registerCells([
            TaskDetailTitleAndDescpCVC.self
        ])
        view.collectionView.contentInset = .init(top: 0, left: 0, bottom: 72, right: 0)
        view.collectionView.dataSource = datasource
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, qos: .background) { [weak self] in
            guard let self = self else { return }
            if /self.viewmodel.task?.reminder {
                ErrorDisplay.error(message: "This is a reminder for task - '\(/self.viewmodel.task?.title)'")
            }
        }
    }
    
    func viewWillDisappear() {
        delegate?.didDeleteTask()
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

extension TaskDetailUIController: TaskDetailBottomViewDelegate {
    func didTapOnEditButton() {
        let viewController = AddTaskViewController()
        viewController.uiController.delegate = self
        viewController.uiController.viewModel.taskConfigurationType = .edit
        viewController.uiController.viewModel.title = viewmodel.task?.title
        viewController.uiController.viewModel.description = viewmodel.task?.description
        viewController.uiController.viewModel.dueDate = viewmodel.task?.dueDate
        viewController.uiController.viewModel.priority = viewmodel.task?.priority ?? .medium
        viewController.uiController.viewModel.location = viewmodel.task?.location
        viewController.uiController.viewModel.reminder = /viewmodel.task?.reminder
        viewController.uiController.viewModel.task = viewmodel.task
        viewController.uiController.viewModel.address = viewmodel.task?.address
        viewController.uiController.viewModel.state = viewmodel.task?.state ?? .created
        let rootVC = UINavigationController(rootViewController: viewController)
        rootVC.navigationBar.isHidden = true
        rootVC.modalPresentationStyle = .overFullScreen
        AppNavigationDelegate.shared.navigationController.present(rootVC, animated: true)
    }
    
    func didTapOnDeleteButton() {
        viewmodel.deleteTask()
    }
}

extension TaskDetailUIController: TaskDetailViewModelDelegates {
    func didDeleteTask() {
        AppNavigationDelegate.shared.navigationController.popViewController(animated: true)
        delegate?.didDeleteTask()
    }
}

extension TaskDetailUIController: AddTaskViewModelDelegates {
    func didAddTask() {
        view?.collectionView.reloadData()
    }
}
