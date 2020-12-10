//
//  MainInteractor.swift
//  FocusStartProject
//
//  Created by Андрей Шамин on 12/7/20.
//

import MapKit

protocol IMainInteractor {
    func loadInitData()
    func cellTapped(atIndexPath indexPath: IndexPath)
}

protocol IMainInteractorOuter: class {
    func setupPlacesCollectionView(withPlaces places: [Place])
    func showOnePlaceVC(withPlace place: Place)
}

protocol IMainLocationManagerDelegate: class {
    func setupUserLocation(withLocation location: CLLocationCoordinate2D)
}

final class MainInteractor {
    weak var presenter: IMainInteractorOuter?
    private var places: [Place] = []
    private var userLocation: CLLocationCoordinate2D?
    private var userLocationManager: UserLocationManager?

}

// MARK: - IMainInteractor

extension MainInteractor: IMainInteractor {
    func cellTapped(atIndexPath indexPath: IndexPath) {
        let chosenPlace = places[indexPath.row]
        self.presenter?.showOnePlaceVC(withPlace: chosenPlace)
    }

    func loadInitData() {
        self.getInitData()
        self.setupLocationManager()
    }
}

private extension MainInteractor {
    func setupLocationManager() {
        userLocationManager = UserLocationManager(delegate: self)
    }
}

// MARK: - IMapLocationManagerDelegate

extension MainInteractor: IUserLocationManager {
    // На случай, если пользователь разрешил отслеживать его местоположение
    // то обновим экран с ближайшими к нему местами
    func returnUserLocation(location: CLLocationCoordinate2D) {
        self.getInitData(withUserLocation: location)
    }
    
    func locationIsnotEnabled() {
        print("locationIsnotEnabled")
    }
}

private extension MainInteractor {
    func getInitData(withUserLocation location: CLLocationCoordinate2D? = nil) {
        PlaceLoader.sharedInstance.loadInitialData { (places) in
            if let location = location {
                let userLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
                self.userLocation = location
                for index in 0...places.count-1{
                    let destination = CLLocation(latitude: places[index].coordinate.latitude, longitude: places[index].coordinate.longitude)
                    let distanceTo = userLocation.distance(from: destination)
                    places[index].distance = Double(distanceTo)
                }
                self.places = places.sorted{ (first, second) -> Bool in
                    first.distance! < second.distance!
                }
            } else {
                self.places = places
            }
            if self.places.count < 20 {
                // Чтобы не показывать на главном экране все заведения,
                // которые у нас есть в списке,
                // будем показывать только первые 20 записей ближайших
                self.presenter?.setupPlacesCollectionView(withPlaces: self.places)
            } else {
                self.presenter?.setupPlacesCollectionView(withPlaces: Array(self.places[...20]))
            }
        }
    }
}
