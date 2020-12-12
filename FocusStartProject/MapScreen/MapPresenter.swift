//
//  MapPresenter.swift
//  FocusStartProject
//
//  Created by Андрей Шамин on 12/8/20.
//

import Foundation
import MapKit

protocol IMapPresenter {
    func viewDidLoad(ui:IMapView)
}

final class MapPresenter {
    private weak var ui: IMapView?
    private var router:IMapRouter
    private var interactor:IMapInteractor

    init(interactor: IMapInteractor, router: IMapRouter) {
        self.interactor = interactor
        self.router = router
    }
}

extension MapPresenter: IMapPresenter {
    func viewDidLoad(ui: IMapView) {
        self.ui = ui

        self.ui?.didSelectSegmentControl = { [weak self] segmentTitle in
            self?.interactor.getPlacesForDiscpline(segmentTitle)
        }

        self.ui?.didTappedAnnotation = { [weak self] place in
            self?.router.goToOnePlace(place)
        }

        self.ui?.didTappedUserLocationButton = { [weak self] in
            self?.interactor.getUserLocation()
        }

        self.interactor.loadInitData()
    }
}

extension MapPresenter: IMapInteractorOuter {
    func setupUserLocation(withLocation location: CLLocationCoordinate2D) {
        self.ui?.setupUserLocation(withLocation: location)
    }

    func returnPlacesDisciplines(_ disciplines: [String]) {
        self.ui?.setupSegmentControl(withDisciplines: disciplines)
    }

    func returnPlacesForDiscipline(places: [Place]) {
        self.ui?.setupAnnotations(forPlaces: places)
    }

    func showAlert(withText text: String) {
        self.router.showAlertWithMessage(text)
    }
}
