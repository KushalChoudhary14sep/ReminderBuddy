//
//  AppCollectionView.swift
//  ReminderBuddy
//
//  Created by Kaushal Chaudhary on 16/06/24.
//

import Foundation
import UIKit
extension UIRefreshControl {
    @objc func didOffsetChanged(point: CGPoint) {
        
    }
}
// MARK: - AppCollectionView
/// A subclass of UICollectionView with additional features:
/// - Set `allowPullToRefresh` to enable or disable Pull to Refresh.
/// - Set `paginator` for pagination support.
/// - Manages the visibility of the bottom loader during pagination.
class AppCollectionView: UICollectionView {
    
    var isHeightExpandable = false
    
    private var height: NSLayoutConstraint!
    
    var minimumHeight: CGFloat = 32
    
    var allowPullToRefresh: Bool = false {
        didSet {
            addRefreshControl()
        }
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: .init(origin: .zero, size: .init(width: 300, height: 50)), collectionViewLayout: layout)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .clear
        UICollectionViewCell.registerTo(collectionView: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        if isHeightExpandable && self.height == nil {
            self.height = self.heightAnchor.constraint(equalToConstant: max(intrinsicContentSize.height, minimumHeight))
            NSLayoutConstraint.activate([
                self.height
            ])
        }
        super.layoutSubviews()
        if isHeightExpandable {
            self.invalidateIntrinsicContentSize()
            self.height.constant = self.intrinsicContentSize.height
        }
    }
    
    override var intrinsicContentSize: CGSize {
        if isHeightExpandable {
            if contentSize.height == 0 {
                return .init(width: 50, height: minimumHeight)
            }
            return contentSize
        }
        return super.intrinsicContentSize
    }
    
    override func reloadData() {
        super.reloadData()
        layoutIfNeeded()
    }
}

//MARK: - Add Refresh Control
private extension AppCollectionView {
    private func addRefreshControl() {
        if self.allowPullToRefresh && self.refreshControl == nil {
            let control = UIRefreshControl()
            control.tintColor = .white
            self.refreshControl = control
        } else if self.allowPullToRefresh == false && self.refreshControl != nil {
            self.refreshControl = nil
        }
    }
}
