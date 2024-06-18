//
//  DashboardDatasoucre.swift
//  ReminderBuddy
//
//  Created by BigOh on 18/06/24.
//

import Foundation
import UIKit

class DashboardDatasoucre: NSObject {
    
    private let viewModel: DashboardViewModel
    
    init(viewModel: DashboardViewModel) {
        self.viewModel = viewModel
    }
}

extension DashboardDatasoucre: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        viewModel.sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = DashboardTaskStatusCell.dequeue(collectionView: collectionView, indexpath: indexPath)
        let section = viewModel.sections[indexPath.section]
        switch section {
        default:
            cell.setData(for: section, tasks: viewModel.tasks)
        }
        return cell
    }
}
