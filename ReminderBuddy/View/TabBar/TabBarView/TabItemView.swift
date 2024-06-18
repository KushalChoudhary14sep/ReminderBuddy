//
//  File.swift
//  ReminderBuddy
//
//  Created by Kaushal Chaudhary on 15/06/24.
//

import Foundation
import UIKit

class TabItemView: UIView {
    deinit {
        print("deiinit TabItemView")
    }
    var didSelected:( (Int) -> Void )?
    var selected:( (Bool) -> Void )?
    var index: Int
    init(item: TabItem,index: Int) {
        self.index = index
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(image)
        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: self.topAnchor, constant: 12),
            image.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            image.heightAnchor.constraint(equalToConstant: 16),
            image.widthAnchor.constraint(equalToConstant: 16)
        ])
        
        let title = UILabel()
        title.textAlignment = .center
        title.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(title)
        title.setContentCompressionResistancePriority(.init(1000), for: .vertical)
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 1),
            title.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 4),
            title.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -4),
        ])
    
        selected = { [weak self] isSelected in
            guard let self = self else { return }
            if isSelected {
                image.image = item.selectedImage
                title.text = item.selectedText
                title.font = .appfont(font: .semiBold, size: 10)
                title.textColor = .white
                self.backgroundColor = .white.withAlphaComponent(0.05)
            } else {
                image.image = item.unselectedImage
                title.text = item.unselectedText
                title.font = .appfont(font: .medium, size: 10)
                title.textColor = .lightText
                self.backgroundColor = .clear
            }
        }
        let button = UIButton(type: .system)
        
        button.addAction(.init(handler: { [weak self] _ in
            guard let self = self else { return }
            self.didSelected?(self.index)
        }), for: .touchUpInside)
        
        self.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            button.topAnchor.constraint(equalTo: self.topAnchor),
            button.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            button.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
