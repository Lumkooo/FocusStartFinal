//
//  BasketInteractor.swift
//  FocusStartProject
//
//  Created by Андрей Шамин on 12/8/20.
//

import Foundation

protocol IBasketInteractor {
    func getInitialData()
    func getData()
    func cellTapped(indexPath: IndexPath)
    func orderButtonTapped()
}

protocol IBasketInteractorOuter: class {
    func basketArrayIsEmpty()
    func passFoodArrayToView(foodArray: [Food])
    func goToOneFoodVC(withFood food: Food)
    func goToPurchasingVC(foodArray: [Food])
}

final class BasketInteractor {
    private var basketArray: [Food] = []
    private var firebaseManager = FirebaseManager()
    weak var presenter: IBasketInteractorOuter?
}

// MARK: - IBasketInteractor

extension BasketInteractor: IBasketInteractor {
    // Чтобы каждый раз не показывать Alert о том, что надо добавить
    // что-то в корзину (думаю это было бы достаточно навязчиво)
    // специально сделал getInitialData() и getData()
    // Первый срабатывает при viewDidLoad метода ViewContorller-а
    // Второй при viewWillAppear
    func getInitialData() {
        if BasketManager.sharedInstance.isEmpty {
            self.presenter?.basketArrayIsEmpty()
        }
        self.passFoodArray()
    }

    func getData() {
        self.passFoodArray()
    }

    func cellTapped(indexPath: IndexPath) {
        self.presenter?.goToOneFoodVC(withFood: self.basketArray[indexPath.row])
    }

    func orderButtonTapped() {
        if self.basketArray.isEmpty {
            self.presenter?.basketArrayIsEmpty()
        } else {
            self.presenter?.goToPurchasingVC(foodArray: self.basketArray)
        }
    }
}

private extension BasketInteractor {
    func passFoodArray() {
        if !BasketManager.sharedInstance.isEmpty &&
            BasketManager.sharedInstance.count != self.basketArray.count {
            self.basketArray = BasketManager.sharedInstance.getBasketArray()
            self.presenter?.passFoodArrayToView(foodArray: self.basketArray)
        } else {
            self.presenter?.passFoodArrayToView(foodArray: self.basketArray)
        }
    }
}
