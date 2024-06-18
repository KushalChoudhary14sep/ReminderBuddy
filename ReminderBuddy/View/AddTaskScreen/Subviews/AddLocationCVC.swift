//
//  AddLocationCVC.swift
//  ReminderBuddy
//
//  Created by BigOh on 17/06/24.
//

import Foundation
import UIKit
import MapKit
import CoreLocation

protocol AddLocationCVCDelegate: AnyObject {
    func didTapSelectLocation()
    func didToggleReminder(isON: Bool)
}

class AddLocationCell: UICollectionViewCell {
    
    weak var delegate: AddLocationCVCDelegate?
        
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.attributedText = NSAttributedString.setAttributedText(text: "Add Location", font: .appfont(font: .medium, size: 16), color: .white)
        return label
    }()
    
    private lazy var locationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .appfont(font: .medium, size: 16)
        label.textColor = .lightGray
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var locationStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, locationLabel, selectLocationButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 12
        stackView.axis = .vertical
        return stackView
    }()
    
    private lazy var addReminderLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.attributedText = NSAttributedString.setAttributedText(text: "Add Reminder", font: .appfont(font: .medium, size: 16), color: .white)
        return label
    }()
    
    lazy var addReminderSwitch: UISwitch = {
        let reminderSwitch = UISwitch()
        reminderSwitch.translatesAutoresizingMaskIntoConstraints = false
        reminderSwitch.isOn = false
        reminderSwitch.addTarget(self, action: #selector(reminderSwitchToggled), for: .valueChanged)
        return reminderSwitch
    }()
    
    
    @objc func reminderSwitchToggled(_ sender: UISwitch) {
        delegate?.didToggleReminder(isON: addReminderSwitch.isOn)
    }
    
    private lazy var selectLocationButton: PrimaryButton = {
        let button = PrimaryButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let image: UIImage = UIImage(systemName: "location.circle.fill")!.withTintColor(Asset.ColorAssets.primaryColor1.color).withRenderingMode(.alwaysOriginal)
        button.setImage(image, for: .normal)
        button.setTitle("   Select Location", for: .normal)
        button.addTarget(self, action: #selector(selectLocationTapped), for: .touchUpInside)
        button.tintColor = .white.withAlphaComponent(0.5)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
        backgroundColor = .clear
        self.locationLabel.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func selectLocationTapped() {
        delegate?.didTapSelectLocation()
    }
    
    private func setupConstraints() {
        contentView.addSubview(addReminderLabel)
        contentView.addSubview(addReminderSwitch)
        contentView.addSubview(locationStackView)
        
        NSLayoutConstraint.activate([
            addReminderLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            addReminderLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),

            addReminderSwitch.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            addReminderSwitch.centerYAnchor.constraint(equalTo: addReminderLabel.centerYAnchor),
            addReminderSwitch.leadingAnchor.constraint(lessThanOrEqualTo: addReminderLabel.trailingAnchor, constant: -16),
            
            selectLocationButton.heightAnchor.constraint(equalToConstant: 44),
            locationStackView.topAnchor.constraint(equalTo: addReminderLabel.bottomAnchor, constant: 24),
            locationStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            locationStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            locationStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
        ])
    }
    
    func setData(location: String?, reminderIsOn: Bool) {
        self.addReminderSwitch.isOn = reminderIsOn
        if let location = location {
            self.locationLabel.isHidden = false
            let attachemnt = NSTextAttachment(image: UIImage(systemName: "location.fill")!.withRenderingMode(.alwaysOriginal).withTintColor(.white))
            let mutableString = NSMutableAttributedString(attachment: attachemnt)
            mutableString.append(NSAttributedString.setAttributedText(text: " \(location)", font: .appfont(font: .semiBold, size: 16), color: .white))
            self.locationLabel.attributedText = mutableString
            self.titleLabel.isHidden = true
        } else {
            self.titleLabel.isHidden = false
            self.locationLabel.isHidden = true
        }
    }
}

class AddressHelper {
    
    static func getAddressFromCoordinates(_ coordinates: CLLocation, completion: @escaping (_ address: String?, _ city: String?, _ state: String?, _ error: Error?) -> Void) {
        let geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(coordinates) { (placemarks, error) in
            if let error = error {
                completion(nil, nil, nil, error)
                return
            }
            
            guard let placemark = placemarks?.first else {
                completion(nil, nil, nil, NSError(domain: "No placemarks found", code: 0, userInfo: nil))
                return
            }
            
            let address = placemark.thoroughfare
            let city = placemark.locality
            let state = placemark.administrativeArea
            
            completion(address, city, state, nil)
        }
    }
    
    static func getCompleteAddress(from location: CLLocation, completion: @escaping (String?) -> Void) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            guard let placemark = placemarks?.first, error == nil else {
                completion(nil)
                return
            }
            
            var addressString = ""
            if let street = placemark.thoroughfare {
                addressString += street + ", "
            }
            if let city = placemark.locality {
                addressString += city + ", "
            }
            if let state = placemark.administrativeArea {
                addressString += state + ", "
            }
            if let postalCode = placemark.postalCode {
                addressString += postalCode + ", "
            }
            if let country = placemark.country {
                addressString += country
            }
            completion(addressString.isEmpty ? nil : addressString)
        }
    }
}
