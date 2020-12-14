//
//  MainInteractor.swift
//  FocusStartProject
//
//  Created by Андрей Шамин on 12/7/20.
//

import MapKit

protocol IMainInteractor {
    func loadInitData()
    func loadLikedRecords()
    func nearestPlacesCellTapped(atIndexPath indexPath: IndexPath)
    func likedPlacesCellTapped(atIndexPath indexPath: IndexPath)
}

protocol IMainInteractorOuter: class {
    func setupPlacesCollectionView(withPlaces places: [Place])
    func setupLikedPlacesCollectionView(withLikedPlaces likedPlaces: [Place])
    func hideLikedPlacesCollectionView()
    func showOnePlaceVC(withPlace place: Place, delegate: ILikedPlacesDelegate)
    func errorOccured(errorDescription: String)
}

protocol ILikedPlacesDelegate {
    func placeAddedToLiked(place: Place)
    func placeRemovedFromLiked(place: Place)
}

protocol IMainLocationManagerDelegate: class {
    func setupUserLocation(withLocation location: CLLocationCoordinate2D)
}

// TODO: - Исправить likedCollectionView (неправильно показывает список избранных при 1-2 записях)

final class MainInteractor {
    weak var presenter: IMainInteractorOuter?
    private var places: [Place] = []
    private var likedPlaces: [Place] = []{
        didSet {
            self.presenter?.setupLikedPlacesCollectionView(withLikedPlaces: self.likedPlaces)
        }
    }
    private var userLocation: CLLocationCoordinate2D?
    private var userLocationManager: UserLocationManager?
    private var firebaseDatabaseManager = FirebaseDatabaseManager()
    private var firebaseAuthManager = FirebaseAuthManager()
}

// MARK: - IMainInteractor

extension MainInteractor: IMainInteractor {
    func loadInitData() {
        self.setupLocationManager()
    }

    func loadLikedRecords() {
        // Если пользователь авторизован, то пробуем достать из Firebase избранные заведения
        if self.firebaseAuthManager.isSignedIn {
            self.firebaseDatabaseManager.getLikedPlaces { (likedPlaces) in
                // в self.likedPlaces отфильтруем и запишем те заведения,
                // которые были добавлены в избранные
                self.likedPlaces = self.places.filter { place in
                    guard let title = place.title,
                          let locationName = place.locationName else {
                        self.presenter?.errorOccured(errorDescription: "Не удалось получить список избранных заведений")
                        assertionFailure("ooops, error with filter")
                        return false
                    }
                    // Возвращаем true в случае, если заведение из place
                    // содержала схожие title и locationName(позволяют точно идентифицировать заведение)
                    // ,как и в записи из Firebase Database
                    return likedPlaces.contains(where: { (likedPlace) -> Bool in
                        if likedPlace.title == title &&
                            likedPlace.locationName == locationName {
                            return true
                        } else {
                            return false
                        }
                    })
                }
            } errorCompletion: {
                self.presenter?.errorOccured(errorDescription: "Не удалось получить список избранных заведений")
            }
        }
    }

    func nearestPlacesCellTapped(atIndexPath indexPath: IndexPath) {
        let chosenPlace = self.places[indexPath.row]
        self.presenter?.showOnePlaceVC(withPlace: chosenPlace, delegate: self)
    }

    func likedPlacesCellTapped(atIndexPath indexPath: IndexPath) {
        if likedPlaces.count > indexPath.row {
            let likedPlace = self.likedPlaces[indexPath.row]
            self.presenter?.showOnePlaceVC(withPlace: likedPlace, delegate: self)
        }
    }
}

private extension MainInteractor {
    func setupLocationManager() {
        self.userLocationManager = UserLocationManager(delegate: self)
    }
}

// MARK: - IMapLocationManagerDelegate

extension MainInteractor: IUserLocationManager {
    // На случай, если пользователь разрешил отслеживать его местоположение
    // то обновим экран с ближайшими к нему местами
    func locationIsEnabled(location: CLLocationCoordinate2D) {
        self.getInitData(withUserLocation: location)
    }
    
    func locationIsnotEnabled() {
        // На случай обработки запрета на использование местоположения
        // Например, выбор города
        self.getInitData()
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
                self.places = places.sorted { (first, second) -> Bool in
                    first.distance ?? 0 < second.distance ?? 0
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

// MARK: - ILikedPlacesDelegate
// (добавление/удаление заведений в список избранных сразу после добавления на экране одного заведения)

extension MainInteractor: ILikedPlacesDelegate {
    func placeAddedToLiked(place: Place) {
        self.likedPlaces.append(place)
        // Если пользователь разрешил использовать местоположение
        // То отсортируем заведения по дистанции до пользователя
        // Если не разрешил, то просто покажем заведения в порядке, как они хранятся в БД
        guard let _ = self.userLocation else {
            return
        }
        self.likedPlaces.sort{ (first, second) -> Bool in
            first.distance ?? 0 < second.distance ?? 0
        }
    }

    func placeRemovedFromLiked(place: Place) {
        self.likedPlaces.removeAll { (removingPlace) -> Bool in
            removingPlace == place
        }
        if self.likedPlaces.count > 0 {
            self.presenter?.setupLikedPlacesCollectionView(withLikedPlaces: self.likedPlaces)
        } else {
            self.presenter?.hideLikedPlacesCollectionView()
        }
    }
}
