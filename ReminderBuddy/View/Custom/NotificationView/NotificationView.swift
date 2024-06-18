//
//  File.swift
//  ReminderBuddy
//
//  Created by Kaushal Chaudhary on 15/06/24.
//

import Foundation
import UIKit


public class NotificationView: UIView {
    private lazy var icon: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var pullDownView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
  
    public static var height: CGFloat = 102
    private static var tag = 9999119
    
    private func setupConstraints() {
        addSubview(icon)
        NSLayoutConstraint.activate([
            icon.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            icon.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            icon.heightAnchor.constraint(equalToConstant: 18),
            icon.widthAnchor.constraint(equalTo: icon.heightAnchor, multiplier: 1)
        ])
        
        addSubview(label)
        NSLayoutConstraint.activate([
            icon.topAnchor.constraint(equalTo: label.topAnchor),
            icon.trailingAnchor.constraint(equalTo: label.leadingAnchor, constant: -8),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
        
        addSubview(pullDownView)
        NSLayoutConstraint.activate([
            pullDownView.heightAnchor.constraint(equalToConstant: 5),
            pullDownView.widthAnchor.constraint(equalToConstant: 32),
            pullDownView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4),
            pullDownView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    
    lazy var blurredView: UIView = {
        let bounds = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: NotificationView.height)
        // 1. create container view
        let containerView = UIView()
        // 2. create custom blur view
        let blurEffect = UIBlurEffect(style: .light)
        let customBlurEffectView = CustomVisualEffectView(effect: blurEffect, intensity: 0.3)
        customBlurEffectView.frame = bounds
        // 3. create semi-transparent black view
        let dimmedView = UIView()
        dimmedView.backgroundColor = .white.withAlphaComponent(0.1)
        dimmedView.frame = bounds
        // 4. add both as subviews
        containerView.addSubview(customBlurEffectView)
        containerView.addSubview(dimmedView)
        return containerView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        self.clipsToBounds = true
        self.layer.cornerRadius = 8
        self.setupConstraints()
        self.pullDownView.clipsToBounds = true
        self.pullDownView.layer.cornerRadius = 2
        self.layer.maskedCorners = [.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
        self.addSubview(blurredView)
        self.sendSubviewToBack(blurredView)
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(didPanOnNotificationView))
        addGestureRecognizer(panGesture)
    }
    
    public static func show(font: UIFont = .systemFont(ofSize: 14), text: String,icon: UIImage? = nil, timeout: Double = 5.0,shouldCleanOldNotifications: Bool = false) {
        let view = NotificationView()
        view.tag = NotificationView.tag
        view.label.font = font
        view.label.text = text
        view.icon.image = icon ?? UIImage(systemName: "xmark.circle.fill")?.withTintColor(.red).withRenderingMode(.alwaysOriginal)
        view.icon.layer.cornerRadius = 8
        view.frame = .init(x: 0, y: -NotificationView.height, width: UIScreen.main.bounds.width, height: NotificationView.height)
        UIView.animate(withDuration: 0.3, delay: 0) {
            view.frame = .init(origin: .zero, size: .init(width: UIScreen.main.bounds.width, height: NotificationView.height))
        }
        guard let window = UIApplication.shared.keyWindow else { return }
        window.subviews.forEach { oldView in
            if oldView.tag == NotificationView.tag {
                oldView.removeFromSuperview()
            }
        }
        window.addSubview(view)
        DispatchQueue.main.asyncAfter(deadline: .now() + timeout) {
            view.hide()
        }
    }
    
    @objc func didPanOnNotificationView(_ sender: UIPanGestureRecognizer) {
        let location = sender.location(in: self).y
        if location < self.frame.height/2 {
            self.hide()
        }
    }
    func hide() {
        UIView.animate(withDuration: 0.3, delay: 0) {
            self.frame = .init(origin: .init(x: 0, y: -NotificationView.height), size: .init(width: UIScreen.main.bounds.width, height: NotificationView.height))
        }completion: { _ in
            self.removeFromSuperview()
        }
    }
}

class TopAlignedLabel: UILabel {
    override func drawText(in rect: CGRect) {
        let textRect = super.textRect(forBounds: bounds, limitedToNumberOfLines: numberOfLines)
        super.drawText(in: textRect)
    }
}
extension Bundle {
    public var icon: UIImage? {
        if let icons = infoDictionary?["CFBundleIcons"] as? [String: Any],
           let primaryIcon = icons["CFBundlePrimaryIcon"] as? [String: Any],
           let iconFiles = primaryIcon["CFBundleIconFiles"] as? [String],
           let lastIcon = iconFiles.last {
            return UIImage(named: lastIcon)
        }
        return nil
    }
}


final class CustomVisualEffectView: UIVisualEffectView {
    /// Create visual effect view with given effect and its intensity
    ///
    /// - Parameters:
    ///   - effect: visual effect, eg UIBlurEffect(style: .dark)
    ///   - intensity: custom intensity from 0.0 (no effect) to 1.0 (full effect) using linear scale
    init(effect: UIVisualEffect, intensity: CGFloat) {
        theEffect = effect
        customIntensity = intensity
        super.init(effect: nil)
    }
    
    required init?(coder aDecoder: NSCoder) { nil }
    
    deinit {
        animator?.stopAnimation(true)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        effect = nil
        animator?.stopAnimation(true)
        animator = UIViewPropertyAnimator(duration: 1, curve: .linear) { [unowned self] in
            self.effect = theEffect
        }
        animator?.fractionComplete = customIntensity
    }
    
    private let theEffect: UIVisualEffect
    private let customIntensity: CGFloat
    private var animator: UIViewPropertyAnimator?
}
