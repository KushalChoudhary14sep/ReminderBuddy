//
//  AddTaskUIController.swift
//  ReminderBuddy
//
//  Created by Kushal Chaudhary on 16/06/24.
//

import Foundation
import UIKit
import CoreLocation

class AddTaskUIController {
    
    weak var view: AddTaskView? {
        didSet {
            guard let view = view else { return }
            viewModel.delegate = self
            configure(view: view)
        }
    }
    
    private lazy var datasource: AddTaskDataSource = {
        let datasource = AddTaskDataSource(viewModel: viewModel)
        datasource.delegate = self
        return datasource
    }()
    
    weak var delegate: AddTaskViewModelDelegates?
    
    let viewModel = AddTaskViewModel()
    private func configure(view: AddTaskView) {
        view.saveButtonView.delegate = self
        view.collectionView.registerCells([
            AddTaskTitleAndDescriptionCVC.self,
            AddDateCell.self,
            AddPriorityCell.self,
            AddLocationCell.self,
            AddStateCell.self
        ])
        view.collectionView.dataSource = datasource
    }
    
    func collectionViewLayout() -> UICollectionViewCompositionalLayout {
          UICollectionViewCompositionalLayout { [weak self] (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
              guard let self = self else { return nil }
              switch self.viewModel.sections[sectionIndex] {
              case .details:
                  let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(330)))
                  let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(330)), subitems: [item])
                  group.interItemSpacing = .fixed(16)
                  let section = NSCollectionLayoutSection(group: group)
                  section.contentInsets = .init(top: 0, leading: 12, bottom: 0, trailing: 12)
                  return section
              case .dueDate:
                  let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(100)))
                  let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(100)), subitems: [item])
                  group.interItemSpacing = .fixed(16)
                  let section = NSCollectionLayoutSection(group: group)
                  section.contentInsets = .init(top: 0, leading: 12, bottom: 0, trailing: 12)
                  return section
              case .location:
                  let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(200)))
                  let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(200)), subitems: [item])
                  group.interItemSpacing = .fixed(16)
                  let section = NSCollectionLayoutSection(group: group)
                  section.contentInsets = .init(top: 0, leading: 12, bottom: 0, trailing: 12)
                  return section
              case .priority:
                  let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(120)))
                  let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(120)), subitems: [item])
                  group.interItemSpacing = .fixed(16)
                  let section = NSCollectionLayoutSection(group: group)
                  section.contentInsets = .init(top: 0, leading: 12, bottom: 0, trailing: 12)
                  return section
              case .state:
                  let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(120)))
                  let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(120)), subitems: [item])
                  group.interItemSpacing = .fixed(16)
                  let section = NSCollectionLayoutSection(group: group)
                  section.contentInsets = .init(top: 0, leading: 12, bottom: 12, trailing: 12)
                  return section
              }
          }
      }
}

extension AddTaskUIController: AddTaskDelegate, MapViewControllerDelegate {
    func didSelectState(state: UserTask.State) {
        viewModel.state = state
    }
    
    func didSelectLocation(location: CLLocation, address: String) {
        viewModel.location = location
        viewModel.address = address
        view?.collectionView.reloadData()
    }
    
    func didTapSelectLocation() {
        let mapVC = MapViewController(location: viewModel.location)
        mapVC.delegate = self
        view?.navigationController?.pushViewController(mapVC, animated: true)
    }
    
    func didToggleReminder(isON: Bool) {
        viewModel.reminder = isON
    }
    
    func didSelectPriority(priority: UserTask.Priority) {
        viewModel.priority = priority
    }
    
    func didSelectDate(date: Date) {
        viewModel.dueDate = date
    }
    
    func didDetailChange(for detailType: DetailType) {
        switch detailType {
        case .title(let newString):
            viewModel.title = newString
        case .description(let newString):
            viewModel.description = newString
        }
    }
}

extension AddTaskUIController: AddTaskBottomViewDelegate {
    func didTapOnSaveButton() {
        guard let taskConfigurationType = viewModel.taskConfigurationType else { return }
        switch taskConfigurationType {
        case .edit:
            viewModel.updaTask()
        case .add:
            viewModel.addTask()
        }
    }
}

extension AddTaskUIController: AddTaskViewModelDelegates {
    func didAddTask() {
        guard let view = view else { return }
        view.navigationController?.dismiss(animated: true, completion: { [weak self] in
            self?.delegate?.didAddTask()
        })
    }
}
