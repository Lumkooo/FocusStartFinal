//
//  BasketPresenter.swift
//  FocusStartProject
//
//  Created by Андрей Шамин on 12/8/20.
//

import Foundation

protocol IBasketPresenter {
    func viewDidLoad(ui: IBasketView)
    func viewWillAppear()
}

final class BasketPresenter {
    private let interactor: IBasketInteractor
    private let router: IBasketRouter
    private weak var ui: IBasketView?

    init(interactor: IBasketInteractor, router: IBasketRouter) {
        self.interactor = interactor
        self.router = router
    }
}

// MARK: - IBasketPresenter

extension BasketPresenter: IBasketPresenter {
    func viewDidLoad(ui: IBasketView) {
        self.ui = ui
        self.ui?.cellTapped = { [weak self] indexPath in
            self?.interactor.cellTapped(indexPath: indexPath)
        }
        self.ui?.orderButtonTapped = { [weak self] in
            self?.interactor.orderButtonTapped()
        }
        self.interactor.getInitialData()
    }

    func viewWillAppear() {
        self.interactor.getData()
    }
}

// MARK: - IBasketInteractorOuter

extension BasketPresenter: IBasketInteractorOuter {
    func goToPurchasingVC(delegate: IBasketScreenDelegate) {
        self.router.showPurchasingVC(delegate: delegate)
    }

    func basketArrayIsEmpty() {
        let alertText = "Вы не добавили ничего в корзину.\nДля оформления заказа надо добавить что-то в корзину!"
        self.router.showAlertWithMessage(alertText)
    }

    func userIsnotSignedIn() {
        let alertText = "Необходимо войти в аккаунт для оформления заказа!"
        self.router.showAlertWithMessage(alertText)
    }


    func passFoodArrayToView(foodArray: [Food]) {
        self.ui?.setupCollectionView(withFoodArray: foodArray)
    }

    func goToOneFoodVC(withFood food: Food) {
        self.router.showFoodVC(withFood: food)
    }
}
