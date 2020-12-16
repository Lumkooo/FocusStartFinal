//
//  MapViewDelegate.swift
//  FocusStartProject
//
//  Created by Андрей Шамин on 12/7/20.
//

import MapKit

final class MapViewDelegate: NSObject {

    //MARK: - Properties

    private var delegate: IMapViewDelegate

    //MARK: - Init

    init(withDelegate delegate: IMapViewDelegate) {
        self.delegate = delegate
    }
}

// MARK: - MKMapViewDelegate

extension MapViewDelegate: MKMapViewDelegate {
    func mapView(_ mapView:MKMapView,
                 annotationView view:MKAnnotationView,
                 calloutAccessoryControlTapped control:UIControl) {

        guard let place = view.annotation as? Place else{
            return
        }
        self.delegate.goToOnePlace(place)
    }

    func mapView(_ mapView: MKMapView,
                 regionDidChangeAnimated animated: Bool) {
        self.delegate.mapWasScrolled()
    }
}
