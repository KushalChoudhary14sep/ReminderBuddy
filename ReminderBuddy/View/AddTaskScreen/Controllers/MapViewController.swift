//  MapViewController.swift
//  ReminderBuddy
//
//  Created by BigOh on 17/06/24.
//

import Foundation
import UIKit
import MapKit
import CoreLocation

protocol MapViewControllerDelegate: AnyObject {
    func didSelectLocation(location: CLLocation, address: String)
}

class MapViewController: UIViewController, CLLocationManagerDelegate {
    
    weak var delegate: MapViewControllerDelegate?
    private var locationManager = CLLocationManager()
    private var selectedLocation: CLLocation? {
        didSet {
            updateLocationLabel()
        }
    }
    
    init(location: CLLocation?) {
        self.selectedLocation = location
        super.init(nibName: nil, bundle: nil)
        self.updateLocationLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.delegate = self
        return mapView
    }()
    
    private lazy var appHeader: AppHeader = {
        let header = AppHeader(title: "Select Location", showBackButton: true)
        header.translatesAutoresizingMaskIntoConstraints = false
        return header
    }()
    
    private lazy var locationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = .appfont(font: .medium, size: 14)
        label.textAlignment = .center
        label.text = "No location selected"
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var selectButton: PrimaryButton = {
        let button = PrimaryButton()
        let image: UIImage = UIImage(systemName: "location.circle.fill")!.withTintColor(Asset.ColorAssets.primaryColor1.color).withRenderingMode(.alwaysOriginal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("    Select Location", for: .normal)
        button.addTarget(self, action: #selector(selectLocationTapped), for: .touchUpInside)
        button.tintColor = .white.withAlphaComponent(0.5)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupLocationManager()
        setupGestureRecognizer()
    }
    
    private func setupView() {
        view.backgroundColor = Asset.ColorAssets.primaryColor1.color
        mapView.layer.cornerRadius = 12
        
        view.addSubview(appHeader)
        view.addSubview(mapView)
        view.addSubview(locationLabel)
        view.addSubview(selectButton)
        
        NSLayoutConstraint.activate([
            appHeader.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            appHeader.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            appHeader.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            mapView.topAnchor.constraint(equalTo: appHeader.bottomAnchor, constant: 12),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            mapView.bottomAnchor.constraint(equalTo: locationLabel.topAnchor, constant: -16),
            
            locationLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            locationLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            locationLabel.bottomAnchor.constraint(equalTo: selectButton.topAnchor, constant: -16),
            
            selectButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            selectButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            selectButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            selectButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    private func setupGestureRecognizer() {
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        mapView.addGestureRecognizer(longPressGesture)
    }
    
    @objc private func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == .began {
            let touchPoint = gestureRecognizer.location(in: mapView)
            let coordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
            
            // Remove existing annotations
            mapView.removeAnnotations(mapView.annotations)
            
            // Add new annotation
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            mapView.addAnnotation(annotation)
            
            // Update selected location
            selectedLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        }
    }
    
    @objc private func selectLocationTapped() {
        guard let location = selectedLocation else { return }
        AddressHelper.getCompleteAddress(from: location) { [weak self] address in
            DispatchQueue.main.async {
                self?.delegate?.didSelectLocation(location: location, address: /address)
            }
        }
        navigationController?.popViewController(animated: true)
    }
    private func updateLocationLabel() {
        guard let location = selectedLocation else {
            locationLabel.text = "No location selected"
            return
        }
        
        mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = location.coordinate
        mapView.addAnnotation(annotation)
        
        AddressHelper.getCompleteAddress(from: location) { [weak self] address in
            DispatchQueue.main.async {
                self?.locationLabel.text = address ?? "No address found"
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(region, animated: true)
        
        // If no location has been selected yet, update the selected location to the current location
        if selectedLocation == nil {
            selectedLocation = location
            mapView.removeAnnotations(mapView.annotations)
            let annotation = MKPointAnnotation()
            annotation.coordinate = location.coordinate
            mapView.addAnnotation(annotation)
        }
    
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get user location: \(error)")
    }
}

extension MapViewController: MKMapViewDelegate {
    // Add MKMapViewDelegate methods here if needed
}
