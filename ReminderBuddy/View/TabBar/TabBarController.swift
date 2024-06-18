//
//  File.swift
//  ReminderBuddy
//
//  Created by Kushal Chaudhary on 15/06/24.
//

import Foundation
import UIKit

class TabBarController: UITabBarController,UITabBarControllerDelegate {
    
    class CustomTabBar : UITabBar {
        override open func sizeThatFits(_ size: CGSize) -> CGSize {
            super.sizeThatFits(size)
            var sizeThatFits = super.sizeThatFits(size)
            sizeThatFits.height = 56
            return sizeThatFits
        }
        override func layoutSubviews() {
            super.layoutSubviews()
            self.subviews.first?.alpha = 0
        }
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        object_setClass(self.tabBar, CustomTabBar.self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func loadView() {
        super.loadView()
        self.view.backgroundColor = Asset.ColorAssets.primaryColor1.color
        
        let homeTabItem: TabItem = .init(
            viewController: HomeViewController(),
            selectedText: Local.Tabbar.home,
            selectedImage: Asset.Assets.tabBarHomeScelected.image.withTintColor(.white),
            unselectedImage: Asset.Assets.tabBarHomeUnscelected.image.withTintColor(.lightText)
        )
        
        let dashboardTabItem: TabItem = .init(
            viewController: DashboardViewController(),
            selectedText: Local.Tabbar.dashboard,
            selectedImage: Asset.Assets.tabBarDashboardScelected.image.withTintColor(.white),
            unselectedImage: Asset.Assets.tabBarDashboardUnscelected.image.withTintColor(.lightText)
        )
        
        let settingsTabItem: TabItem = .init(
            viewController: SettingsViewController(),
            selectedText: Local.Tabbar.settings,
            selectedImage: Asset.Assets.tabBarSettingsScelectedPng.image.withTintColor(.white),
            unselectedImage: Asset.Assets.tabBarSettingsUnscelectedPng.image.withTintColor(.lightText)
        )

        let tabbar = TabBarView(
            selectedBackgroundColor: Asset.ColorAssets.primaryColor3.color,
            unselectedBackgroundColor: .white,
            indicatorColor: Asset.ColorAssets.primaryColor1.color,
            items: [homeTabItem, dashboardTabItem, settingsTabItem],
            inTabController: self
        )
        
        tabbar.translatesAutoresizingMaskIntoConstraints = false
        self.tabBar.addSubview(tabbar)
        tabbar.heightAnchor.constraint(equalToConstant: 56).isActive = true
        NSLayoutConstraint.activate([
            tabbar.leadingAnchor.constraint(equalTo: self.tabBar.safeAreaLayoutGuide.leadingAnchor),
            tabbar.trailingAnchor.constraint(equalTo: self.tabBar.safeAreaLayoutGuide.trailingAnchor),
            tabbar.bottomAnchor.constraint(equalTo: self.tabBar.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.tabBar.window?.backgroundColor = .white
        let frame: CGRect = .init(x: 0, y: 0, width: /AppNavigationDelegate.shared.window?.bounds.width, height: /AppNavigationDelegate.shared.window?.bounds.height - 34)
        self.view.frame = frame
    }
}
