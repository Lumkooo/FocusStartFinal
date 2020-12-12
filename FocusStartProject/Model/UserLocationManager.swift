//
//  UserLocationManager.swift
//  FocusStartProject
//
//  Created by Андрей Шамин on 12/9/20.
//

import Foundation
import MapKit


protocol IUserLocationManager: class {
    func locationIsEnabled(location: CLLocationCoordinate2D)
    func locationIsnotEnabled()
}

final class UserLocationManager {

    // MARK: - Properties

    private var locationManager:CLLocationManager!
    private var mapViewLocationManagerDelegate: MapViewLocationManagerDelegate?
    private var userLocation: CLLocationCoordinate2D?
    private var delegate: IUserLocationManager
    // MARK: - Init

    init(delegate: IUserLocationManager) {
        self.delegate = delegate
        self.locationManager = CLLocationManager()
        self.mapViewLocationManagerDelegate = MapViewLocationManagerDelegate(withDelegate: self)
        self.locationManager.delegate = mapViewLocationManagerDelegate
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled(){
            self.locationManager.startUpdatingLocation()
        } else {
            self.delegate.locationIsnotEnabled()
        }
    }
}

extension UserLocationManager: IMapLocationManagerDelegate {
    func setupUserLocation(withLocation location: CLLocationCoordinate2D) {
        self.delegate.locationIsEnabled(location: location)
    }
}
