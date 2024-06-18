//
//  TaskDetailDataosurce.swift
//  ReminderBuddy
//
//  Created by Kushal Choudahry on 17/06/24.
//

import Foundation
import UIKit

class TaskDetailDataosurce: NSObject {
    
    private let viewModel: TaskDetailViewModel
    
    init(viewModel: TaskDetailViewModel) {
        self.viewModel = viewModel
    }
}

extension TaskDetailDataosurce: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        viewModel.sections.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch viewModel.sections[indexPath.section] {
        case .detail:
            let cell = TaskDetailTitleAndDescpCVC.dequeue(collectionView: collectionView, indexpath: indexPath)
            guard let task = viewModel.task else { return cell }
            cell.setData(task: task)
            return cell
        }
    }
}
