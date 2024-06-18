//
//  Paginator.swift
//  ReminderBuddy
//
//  Created by Kaushal Chaudhary on 16/06/24.
//

import Foundation
import Foundation

// MARK: - PaginatorDelegate
/// A protocol defining methods for notifying a delegate about pagination events.
protocol PaginatorDelegate: AnyObject {
    
    /// Notifies the delegate that pagination is requested for a specific page.
    ///
    /// - Parameters:
    ///   - page: The target page for pagination.
    ///   - paginator: The paginator triggering the pagination event.
    func paginate(to page: Int,for paginator: Paginator)
}

// MARK: - Paginator
/// A class responsible for managing pagination and notifying its delegate about pagination events.
class Paginator {
    
    private var page: Int = -1
    private var previousItemCount: Int = -1
    private var currentPage: Int {
        return page
    }
    
    init(delegate: PaginatorDelegate) {
        self.pagingDelegate = delegate
    }
    
    weak var pagingDelegate: PaginatorDelegate? {
        didSet {
            pagingDelegate?.paginate(to: page, for: self)
        }
    }
}

// MARK: - Paginator - viewingItemAt
extension Paginator {
    
    /// Use this method to trigger pagination based on the current viewing items at a specific index path.
    ///
    /// - Parameters:
    ///   - indexPath: The index path of the currently viewed item.
    ///   - currentItemCount: The total count of the current items.
    func viewingItemAt(indexPath: IndexPath, currentItemCount: Int) {
        paginate(currentItemCount, forIndexAt: indexPath)
    }
}

// MARK: - Paginator - reset
extension Paginator {
    
    /// Use this method to reset the paginator to its initial state.
    func reset() {
        page = 0
        previousItemCount = -1
        pagingDelegate?.paginate(to: page, for: self)
    }
}

// MARK: - Paginator - paginate
private extension Paginator {
    
    /// Private method to handle the pagination logic.
    ///
    /// - Parameters:
    ///   - totalItems: The total count of items.
    ///   - indexPath: The index path of the currently viewed item.
    private func paginate(_ totalItems:Int, forIndexAt indexPath: IndexPath) {
        let itemCount = totalItems
        guard indexPath.section == itemCount - 1 else {
            return
        }
        guard previousItemCount != itemCount else {
            return
        }
        page += 1
        previousItemCount = itemCount
        pagingDelegate?.paginate(
            to: page,
            for: self
        )
    }
}
