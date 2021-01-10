//
//  MapViewLocationManagerDelegate.swift
//  FocusStartProject
//
//  Created by Андрей Шамин on 12/7/20.
//

import MapKit

protocol IMapLocationManagerDelegate: class {
    func setupUserLocation(withLocation location: CLLocationCoordinate2D)
}

final class MapViewLocationManagerDelegate: NSObject {
    
    //MARK: - Properties
    
    private var delegate: IMapLocationManagerDelegate
    
    //MARK: - Init
    
    init(withDelegate delegate: IMapLocationManagerDelegate) {
        self.delegate = delegate
    }
}

// MARK: - CLLocationManagerDelegate

extension MapViewLocationManagerDelegate: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else {
            assertionFailure("oops, something went wrong")
            return
        }
        delegate.setupUserLocation(withLocation: locValue)
    }
}
