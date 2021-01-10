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
    func userIsnotSignedIn()
    func passFoodArrayToView(foodArray: [Food])
    func goToOneFoodVC(withFood food: Food)
    func goToPurchasingVC(delegate: IBasketScreenDelegate)
}

protocol IBasketScreenDelegate {
    func reloadViewAfterPurchasing()
}

final class BasketInteractor {

    // MARK: - Properties

    private var basketArray: [Food] = []
    private var firebaseAuthManager = FirebaseAuthManager()
    weak var presenter: IBasketInteractorOuter?
}

// MARK: - IBasketInteractor

extension BasketInteractor: IBasketInteractor {
    // Чтобы каждый раз не показывать Alert о том, что надо добавить
    // что-то в корзину (думаю это было бы достаточно навязчиво)
    // специально сделал getInitialData() и getData()
    // Первый срабатывает при viewDidLoad метода ViewContorller-а и показывает Alert, если корзина пустая
    // Второй при viewWillAppear и не показывает Alert-ов
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
        } else if !self.firebaseAuthManager.isSignedIn {
            self.presenter?.userIsnotSignedIn()
        } else {
            self.presenter?.goToPurchasingVC(delegate: self)
        }
    }
}

// MARK: - Передача данных к UI

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

// MARK: - IBasketScreenDelegate
// Обновление списка товаров в корзине, если новый товар был добавлен в корзину
// после загрузки BasketScreen-а

extension BasketInteractor: IBasketScreenDelegate {
    func reloadViewAfterPurchasing() {
        self.basketArray = BasketManager.sharedInstance.getBasketArray()
        self.presenter?.passFoodArrayToView(foodArray: self.basketArray)
    }
}
