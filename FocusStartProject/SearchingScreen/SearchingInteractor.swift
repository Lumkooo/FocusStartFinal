//
//  SearchingInteractor.swift
//  FocusStartProject
//
//  Created by Андрей Шамин on 12/14/20.
//

import Foundation

protocol ISearchingInteractor {
    func loadInitData()
    func searchForPlace(withText text: String, category: String)
    func cellTapped(indexPath: IndexPath)
}

protocol ISearchingInteractorOuter: class {
    func returnFilteredPlaces(places: [Place])
    func goToOnePlaceVC(place: Place, delegate: ILikedPlacesDelegate)
    func showAlert(withText text: String)
}

final class SearchingInteractor {
    
    // MARK: - Properties
    
    weak var presenter: ISearchingInteractorOuter?
    private var places: [Place] = []
    private var delegate: ILikedPlacesDelegate
    private var filteredPlaces: [Place] = []
    
    // MARK: - Init
    
    init(delegate: ILikedPlacesDelegate) {
        self.delegate = delegate
    }
}

// MARK: - ISearchingInteractor

extension SearchingInteractor: ISearchingInteractor {
    func loadInitData() {
        PlaceLoader.sharedInstance.loadInitialData(completion: { (places) in
            self.places = self.getEveryPlaceOnce(places: places)
            self.filteredPlaces = self.places
            self.presenter?.returnFilteredPlaces(places: self.filteredPlaces)
        }, errorCompletion: { errorDescription in
            self.presenter?.showAlert(withText: errorDescription)
        })
    }
    
    func searchForPlace(withText text: String, category: String) {
        self.filteredPlaces = self.filterByCategory(category)
        self.filteredPlaces = self.filterPlaces(text: text,
                                                sortingPlaces: self.filteredPlaces)
        self.presenter?.returnFilteredPlaces(places: filteredPlaces)
    }
    
    func cellTapped(indexPath: IndexPath) {
        let place = self.filteredPlaces[indexPath.row]
        self.presenter?.goToOnePlaceVC(place: place, delegate: self.delegate)
    }
}

private extension SearchingInteractor {
    // Поиск среди названий заведений
    func filterPlaces(text: String, sortingPlaces: [Place]) -> [Place]{
        var filteredPlaces: [Place] = []
        if text == "" {
            // Текст поиска пустой, покаызваем все заведения
            return sortingPlaces
        }
        sortingPlaces.forEach { place in
            // Проверяем на наличие text-а в title заведений
            guard let title = place.title  else { return }
            // lowercased() на случай того, если пользователь вводит
            // прописными(капсом(, а заведения написано строчными(обычными)
            if title.lowercased().contains(text.lowercased()) {
                filteredPlaces.append(place)
            }
        }
        return filteredPlaces
    }
    
    // Этот метод из всего списка заведений оставляет только по одному заведению от сети
    // (То есть, от 10+ McDonald's-ов останется только один)
    func getEveryPlaceOnce(places: [Place]) -> [Place] {
        // clearPlaces - массив, где каждое заведение от сети встречается только раз
        var clearPlaces: [Place] = []
        places.forEach { place in
            if !clearPlaces.contains(where: { (filteredPlace) -> Bool in
                filteredPlace.title == place.title
            }) {
                clearPlaces.append(place)
            }
        }
        return clearPlaces
    }
    
    /// Сортировка по категории заведения
    func filterByCategory(_ category: String) -> [Place] {
        var filteredPlaces: [Place] = []
        if category == "Все" {
            // Поиск по всем заведениям
            return self.places
        }
        self.places.forEach { place in
            // Проверяем принадлежит ли это место к искомой категории
            guard let discipline = place.discipline  else { return }
            if discipline == category {
                filteredPlaces.append(place)
            }
        }
        return filteredPlaces
    }
}
