//
//  HomeDataSource.swift
//  ReminderBuddy
//
//  Created by Kushal Chaudhary on 16/06/24.
//

import Foundation
import UIKit

protocol HomeDelegate: AnyObject {
    func didSelectTask(task: UserTask)
}

class HomeDataSource: NSObject {
    private let viewModel: HomeViewModel
    
    weak var delegate: HomeDelegate?
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
    }
}

extension HomeDataSource: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.tasks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = TaskListCVC.dequeue(collectionView: collectionView, indexpath: indexPath)
        cell.setData(task: viewModel.tasks[indexPath.row])
        return cell
    }
}

extension HomeDataSource: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let task = viewModel.tasks[indexPath.row]
        delegate?.didSelectTask(task: task)
    }
}
