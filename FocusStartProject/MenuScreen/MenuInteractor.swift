//
//  MenuInteractor.swift
//  FocusStartProject
//
//  Created by Андрей Шамин on 12/8/20.
//

import Foundation

protocol IMenuInteractor {
    func loadFoodForPlace()
    func cellTapped(indexPath: IndexPath)
}

protocol IMenuPresenterOuter: class {
    func passFoodArrayToView(foodArray: [Food])
    func goToOneFoodVC(withFood food: Food)
    func alertOccured(stringError: String)
}

final class MenuInteractor {
    private var place: Place
    private var foodArray: [Food] = []
    weak var presenter: IMenuPresenterOuter?

    init(place: Place) {
        self.place = place
    }
}

extension MenuInteractor: IMenuInteractor {
    func loadFoodForPlace() {
        FoodLoader.loadFoodFor(place: self.place) { (foodArray) in
            self.foodArray = foodArray
            self.presenter?.passFoodArrayToView(foodArray: foodArray)
        } errorCompletion: { (stringError) in
            self.presenter?.alertOccured(stringError: stringError)
        }
    }

    func cellTapped(indexPath: IndexPath) {
        // Если пользователь выбирает ячейку, то параметру
        // address экземпляра food присваиваем
        // значение параметра locationName экзмепляра place
        // для того, чтобы в истории покупок в профиле пользователя
        // можно было видеть где был куплен товар
        self.foodArray[indexPath.row].address = self.place.locationName
        self.presenter?.goToOneFoodVC(withFood: self.foodArray[indexPath.row])
    }
}
