//
//  MapView.swift
//  FocusStartProject
//
//  Created by Андрей Шамин on 12/8/20.
//

import UIKit
import MapKit

protocol IMapView: class {
    var didSelectSegmentControl: ((String) -> Void)? { get set }
    var didTappedAnnotation: ((Place) -> Void)? { get set }
    var didTappedUserLocationButton: (() -> Void)? { get set }
    
    func setupSegmentControl(withDisciplines disciplines: [String])
    func setupAnnotations(forPlaces places:[Place])
    func setupUserLocation(withLocation location: CLLocationCoordinate2D)
    func setupCityLocation()
}

protocol IMapViewDelegate: class {
    func goToOnePlace(_ place: Place)
    func mapWasScrolled()
}

final class MapView: UIView {
    
    // MARK: - Constants
    
    private enum Constants {
        static let mapSpan = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        static let userLocationButtonCornerRadius: CGFloat = 5
    }
    
    // MARK: - Views
    
    private let segmentControl: UISegmentedControl = {
        let segmentControl = UISegmentedControl()
        segmentControl.addTarget(self, action: #selector(segmentControlAction(sender:)), for: .valueChanged)
        return segmentControl
    }()
    
    private let mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.setUserTrackingMode(.follow, animated: true)
        mapView.mapType = MKMapType.standard
        mapView.register(PlacesArtowrkView.self,
                         forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        return mapView
    }()
    
    private let userLocationButton: UIButton = {
        let myButton = UIButton()
        myButton.backgroundColor = UIColor.white.withAlphaComponent(0.75)
        myButton.setImage(AppConstants.Images.userLocationButtonImage, for: .normal)
        myButton.layer.cornerRadius = Constants.userLocationButtonCornerRadius
        myButton.addTarget(self, action: #selector(userLocationButtonTapped(gesture:)), for: .touchUpInside)
        return myButton
    }()
    
    // MARK: - Properties
    
    var didSelectSegmentControl: ((String) -> Void)?
    var mapViewDelegate: MapViewDelegate?
    var didTappedAnnotation: ((Place) -> Void)?
    var didTappedUserLocationButton: (() -> Void)?
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .systemBackground
        self.setupElements()
        self.setupDelegates()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Обработка нажатий на segmentControl

private extension MapView {
    @objc func segmentControlAction(sender: UISegmentedControl) {
        self.selectSegmentControl(sender: sender)
    }
    
    @objc func userLocationButtonTapped(gesture: UIGestureRecognizer) {
        self.didTappedUserLocationButton?()
    }
}

// MARK: - IMapView

extension MapView: IMapView {
    func setupSegmentControl(withDisciplines disciplines: [String]) {
        for discipline in disciplines {
            let index = self.segmentControl.numberOfSegments
            self.segmentControl.insertSegment(withTitle: discipline,
                                              at: index, animated: true)
        }
        if self.segmentControl.numberOfSegments > 0 {
            self.segmentControl.selectedSegmentIndex = 0
            self.selectSegmentControl(sender: self.segmentControl)
        }
    }
    
    private func selectSegmentControl(sender: UISegmentedControl) {
        guard let segmentControlTitle = segmentControl.titleForSegment(at: sender.selectedSegmentIndex)
        else {
            assertionFailure("Something went wrong")
            return
        }
        self.didSelectSegmentControl?(segmentControlTitle)
    }
    
    func setupAnnotations(forPlaces places:[Place]) {
        let currentAnnotations = self.mapView.annotations
        self.mapView.removeAnnotations(currentAnnotations)
        mapView.addAnnotations(places)
    }

    // Используется, если пользователь разрешил использовать его местоположение
    func setupUserLocation(withLocation location: CLLocationCoordinate2D) {
        let region = MKCoordinateRegion(center: location, span: Constants.mapSpan)
        print(location)
        self.mapView.setRegion(region, animated: true)
        self.userLocationButton.setImage(AppConstants.Images.userLocationButtonImageFilled, for: .normal)
    }

    // Используется, если пользователь не разрешил использовать его местоположение
    // Просто показывается карта New-York-а
    func setupCityLocation() {
        let center = CLLocationCoordinate2D(latitude: 40.75, longitude: -73.98)
        let region = MKCoordinateRegion(center: center, span: Constants.mapSpan)
        self.mapView.setRegion(region, animated: true)
    }
}

// MARK: - Setup UI

private extension MapView {
    func setupElements() {
        self.setupSegmentController()
        self.setupMapView()
        self.setupLocationButton()
    }
    
    func setupDelegates() {
        mapViewDelegate = MapViewDelegate(withDelegate: self)
        self.mapView.delegate = mapViewDelegate
    }
    
    func setupSegmentController() {
        self.addSubview(self.segmentControl)
        self.segmentControl.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.segmentControl.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            self.segmentControl.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            self.segmentControl.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    func setupMapView() {
        self.addSubview(self.mapView)
        self.mapView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.mapView.topAnchor.constraint(equalTo: self.segmentControl.bottomAnchor),
            self.mapView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            self.mapView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            self.mapView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func setupLocationButton() {
        self.addSubview(self.userLocationButton)
        self.userLocationButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.userLocationButton.topAnchor.constraint(equalTo: self.mapView.topAnchor,
                                                         constant: AppConstants.Constraints.normalAnchorConstant),
            self.userLocationButton.trailingAnchor.constraint(equalTo: self.mapView.trailingAnchor,
                                                              constant: -AppConstants.Constraints.normalAnchorConstant),
            self.userLocationButton.heightAnchor.constraint(equalToConstant: AppConstants.Sizes.userLocationButtonSize.height),
            self.userLocationButton.widthAnchor.constraint(equalToConstant: AppConstants.Sizes.userLocationButtonSize.width)
        ])
    }
}

// MARK: - IMapViewDelegate

extension MapView: IMapViewDelegate {
    func goToOnePlace(_ place: Place) {
        self.didTappedAnnotation?(place)
    }
    
    func mapWasScrolled() {
        if self.userLocationButton.image(for: .normal) != AppConstants.Images.userLocationButtonImage{
            self.userLocationButton.setImage(AppConstants.Images.userLocationButtonImage, for: .normal)
        }
    }
}
