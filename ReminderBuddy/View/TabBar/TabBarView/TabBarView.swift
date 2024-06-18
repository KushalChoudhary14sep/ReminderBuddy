//
//  File.swift
//  ReminderBuddy
//
//  Created by Kushal Chaudhary on 15/06/24.
//

import Foundation
import UIKit

struct TabItem {
    weak var viewController: UIViewController!
    let selectedText: String
    let unselectedText: String
    let selectedImage: UIImage
    let unselectedImage: UIImage
    init(viewController: UIViewController, selectedText: String, unselectedText: String? = nil, selectedImage: UIImage, unselectedImage: UIImage) {
        let nav = UINavigationController(rootViewController: viewController)
        nav.isNavigationBarHidden = true
        self.viewController = nav
        self.selectedText = selectedText
        self.unselectedText = unselectedText ?? selectedText
        self.selectedImage = selectedImage
        self.unselectedImage = unselectedImage
    }
}

final class TabBarView: UIView {
    
    let selectedBackgroundColor: UIColor
    let unselectedBackgroundColor: UIColor
    let indicatorColor: UIColor
    let items: [TabItem]
    weak var tabController: UITabBarController?
    
    var selectedIndex = 0
    
    init(selectedBackgroundColor: UIColor, unselectedBackgroundColor: UIColor, indicatorColor: UIColor, items: [TabItem],inTabController: UITabBarController) {
        self.selectedBackgroundColor = selectedBackgroundColor
        self.unselectedBackgroundColor = unselectedBackgroundColor
        self.indicatorColor = indicatorColor
        self.items = items
        self.tabController = inTabController
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        self.backgroundColor = Asset.ColorAssets.primaryColor1.color
        
        let line: UIView = {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.heightAnchor.constraint(equalToConstant: 1).isActive = true
            view.backgroundColor = Asset.ColorAssets.background1.color
            return view
        }()
        
        self.addSubview(line)
        NSLayoutConstraint.activate([
            line.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            line.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            line.topAnchor.constraint(equalTo: self.topAnchor)
        ])
        let stack = UIStackView()
        
        func generateTabItem(for item: TabItem,index: Int) -> UIView {
            let view = TabItemView(item: item, index: index)
            view.didSelected = { [weak self] index in
                stack.subviews.forEach { view in
                    (view as? TabItemView)?.selected?(false)
                }
                view.selected?(true)
                self?.tabController?.selectedIndex = index
            }
            view.selected?(false)
            return view
        }
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        
        var count = 0
        self.items.forEach({ item in
            stack.addArrangedSubview(generateTabItem(for: item, index: count))
            count = count + 1
        })
        
        let vcs = self.items.reduce([UIViewController]()) { partialResult, item in
            var new = partialResult
            new.append(item.viewController)
            return new
        }
        
        self.tabController?.setViewControllers(vcs, animated: true)
        self.addSubview(stack)
        stack.spacing = 0
        stack.distribution = .fillEqually
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            stack.topAnchor.constraint(equalTo: self.topAnchor),
        ])
        (stack.subviews.first as? TabItemView)?.selected?(true)
    }
}
