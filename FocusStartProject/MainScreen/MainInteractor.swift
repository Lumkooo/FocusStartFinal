//
//  MainInteractor.swift
//  FocusStartProject
//
//  Created by Андрей Шамин on 12/7/20.
//

import MapKit

protocol IMainInteractor {
    func loadInitData()
    func loadLikedPlaces()
    func nearestPlacesCellTapped(atIndexPath indexPath: IndexPath)
    func likedPlacesCellTapped(atIndexPath indexPath: IndexPath)
    func prepareForSearchVC()
}

protocol IMainInteractorOuter: class {
    func setupPlacesCollectionView(withPlaces places: [Place])
    func prepareForLikedPlaces()
    func setupLikedPlacesCollectionView(withLikedPlaces likedPlaces: [Place])
    func showOnePlaceVC(withPlace place: Place, delegate: ILikedPlacesDelegate)
    func errorOccured(errorDescription: String)
    func goToSearchVC(delegate: ILikedPlacesDelegate)
}

protocol ILikedPlacesDelegate {
    func placeAddedToLiked(place: Place)
    func placeRemovedFromLiked(place: Place)
}

protocol IMainLocationManagerDelegate: class {
    func setupUserLocation(withLocation location: CLLocationCoordinate2D)
}

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
        // Попытка получить местоположение пользователя
        // Если местоположение получено, то выведутся места отсортированные по близости к пользователю
        // если получить местоположение не удалось, то просто выведется список мест
        self.setupLocationManager()
        self.setupNotifications()
    }

    func loadLikedPlaces() {
        // Если пользователь авторизован, то пробуем достать из Firebase избранные заведения
        if self.firebaseAuthManager.isSignedIn {
            // Запуск activityIndicator-а
            self.presenter?.prepareForLikedPlaces()
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
                // self.likedPlaces - пустой, отправялем во View пустой массив
                // View тем самым уберет activityIndicator
                self.presenter?.setupLikedPlacesCollectionView(withLikedPlaces: self.likedPlaces)
                self.presenter?.errorOccured(errorDescription: "Не удалось получить список избранных заведений")
            }
        } else {
            // Если пользователь не авторизован, то ничего не показываем,
            // если что-то уже было в массиве, то убираем это
            self.likedPlaces.removeAll()
            self.presenter?.setupLikedPlacesCollectionView(withLikedPlaces: self.likedPlaces)
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

    func prepareForSearchVC() {
        self.presenter?.goToSearchVC(delegate: self)
    }
}

// MARK: - Настройка userLocationManager

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
        // в будущем, например, выбор города
        // сейчас это не нужно, потому что даже один город полностью покрыть не удалось
        self.getInitData()
    }
}

// MARK: - Получение списка заведений

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
                PlaceLoader.sharedInstance.setPlacesByLocation(places: self.places)
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
        } errorCompletion: { errorDescription in
            self.presenter?.errorOccured(errorDescription: errorDescription)
        }
    }
}

// MARK: - ILikedPlacesDelegate
// (добавление/удаление заведений в список избранных сразу после добавления на экране одного заведения)

extension MainInteractor: ILikedPlacesDelegate {
    func placeAddedToLiked(place: Place) {
        self.likedPlaces.append(place)
    }

    func placeRemovedFromLiked(place: Place) {
        self.likedPlaces.removeAll { (removingPlace) -> Bool in
            removingPlace == place
        }
    }
}


// MARK: - Настройка NotificationCenter

private extension MainInteractor {
    func setupNotifications() {
        // Notification вызывается в LoginInteractor и в ProfileInteractor
        // Обновляет список избранных мест после авторизации/выхода из аккаунта
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(refreshLikedPlacesAfterAuthActions(_:)),
                                               name: NSNotification.Name(
                                                rawValue: AppConstants.NotificationNames.refreshLikedPlaces),
                                               object: nil)
    }

    /// Перезагрузить список избранных мест после авторизации/выхода из аккаунта
    @objc func refreshLikedPlacesAfterAuthActions(_ notification:Notification) {
        // TODO: - логика
        self.loadLikedPlaces()
    }
}
