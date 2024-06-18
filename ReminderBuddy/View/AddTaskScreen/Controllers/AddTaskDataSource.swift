//
//  AddTaskDataSource.swift
//  ReminderBuddy
//
//  Created by Kaushal Chaudhary on 16/06/24.
//

import Foundation
import UIKit

protocol AddTaskDelegate: AddTaskTitleAndDescriptionCVCDelegate, AddDateCVCDelegate, AddPriorityCVCDelegate, AddLocationCVCDelegate, AddStateCVCDelegate {
}

class AddTaskDataSource: NSObject {
    private let viewModel: AddTaskViewModel
    
    weak var delegate: AddTaskDelegate?
        
    init(viewModel: AddTaskViewModel) {
        self.viewModel = viewModel
    }
}

extension AddTaskDataSource: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        viewModel.sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch viewModel.sections[indexPath.section] {
        case .details:
            let cell = AddTaskTitleAndDescriptionCVC.dequeue(collectionView: collectionView, indexpath: indexPath)
            cell.setTitle(title: viewModel.title, description: viewModel.description)
            cell.delegate = self
            return cell
        case .dueDate:
            let cell = AddDateCell.dequeue(collectionView: collectionView, indexpath: indexPath)
            cell.delegate = self
            cell.setDate(date: viewModel.dueDate)
            return cell
        case .location:
            let cell = AddLocationCell.dequeue(collectionView: collectionView, indexpath: indexPath)
            cell.delegate = self
            cell.setData(location: viewModel.address, reminderIsOn: viewModel.reminder)
            return cell
        case .priority:
            let cell = AddPriorityCell.dequeue(collectionView: collectionView, indexpath: indexPath)
            cell.delegate = self
            cell.setPriority(priority: viewModel.priority)
            return cell
        case .state:
            let cell = AddStateCell.dequeue(collectionView: collectionView, indexpath: indexPath)
            cell.delegate = self
            cell.setState(task: viewModel.task)
            return cell
        }
    }
}

extension AddTaskDataSource: AddTaskTitleAndDescriptionCVCDelegate {
    func didDetailChange(for detailType: DetailType) {
        delegate?.didDetailChange(for: detailType)
    }
}

extension AddTaskDataSource: AddDateCVCDelegate {
    func didSelectDate(date: Date) {
        delegate?.didSelectDate(date: date)
    }
}

extension AddTaskDataSource: AddPriorityCVCDelegate {
    func didSelectPriority(priority: UserTask.Priority) {
        delegate?.didSelectPriority(priority: priority)
    }
}

extension AddTaskDataSource: AddLocationCVCDelegate {
    func didTapSelectLocation() {
        delegate?.didTapSelectLocation()
    }
    
    func didToggleReminder(isON: Bool) {
        delegate?.didToggleReminder(isON: isON)
    }
}

extension AddTaskDataSource: AddStateCVCDelegate {
    func didSelectState(state: UserTask.State) {
        viewModel.state = state
    }
}
