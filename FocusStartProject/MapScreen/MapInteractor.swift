//
//  MapInteractor.swift
//  FocusStartProject
//
//  Created by Андрей Шамин on 12/8/20.
//

import Foundation
import MapKit

protocol IMapInteractor {
    func loadInitData()
    func getPlacesForDiscpline(_ discpline: String)
    func getUserLocation()
}

protocol IMapInteractorOuter: class {
    func returnPlacesDisciplines(_ disciplines: [String])
    func returnPlacesForDiscipline(places: [Place])
    func setupUserLocation(withLocation location: CLLocationCoordinate2D)
    func setupCityLocation()
    func showAlert(withText text:String)
}

final class MapInteractor {
    
    // MARK: - Properties
    
    weak var presenter: IMapInteractorOuter?
    private var places: [Place] = []
    private var userLocation: CLLocationCoordinate2D?
    private var userLocationManager: UserLocationManager?
}

// MARK: - IMapInteractor

extension MapInteractor: IMapInteractor {
    func loadInitData() {
        PlaceLoader.sharedInstance.loadInitialData { (places) in
            self.places = places
            let disciplines = PlaceLoader.sharedInstance.getDisciplines()
            self.presenter?.returnPlacesDisciplines(disciplines)
        } errorCompletion: { errorDescription in
            self.presenter?.showAlert(withText: errorDescription)
        }
        self.setupLocationManager()
    }
    
    func getPlacesForDiscpline(_ discpline: String) {
        let placesForDiscipline = PlaceLoader.sharedInstance.getPlacesForDiscpline(discpline)
        self.presenter?.returnPlacesForDiscipline(places: placesForDiscipline)
    }
    
    func getUserLocation() {
        if let userLocation = self.userLocation  {
            self.presenter?.setupUserLocation(withLocation: userLocation)
        } else {
            self.presenter?.showAlert(withText: "Мы не можем получить ваше местоположение")
        }
    }
}

// MARK: - установка userLocationManager

private extension MapInteractor {
    func setupLocationManager() {
        userLocationManager = UserLocationManager(delegate: self)
    }
}

// MARK: - IUserLocationManager

extension MapInteractor: IUserLocationManager {
    func locationIsnotEnabled() {
        // Не удалось получить местоположение пользователя
        // Просто покажем карту New-York-а
        self.presenter?.setupCityLocation()
    }
    
    func locationIsEnabled(location: CLLocationCoordinate2D) {
        self.userLocation = location
        self.presenter?.setupUserLocation(withLocation: location)
    }
}
