//
//  MenuPresenter.swift
//  FocusStartProject
//
//  Created by Андрей Шамин on 12/8/20.
//

import Foundation

protocol IMenuPresenter {
    func viewDidLoad(ui: IMenuView)
}

final class MenuPresenter {
    private var router: IMenuRouter
    private var interactor: IMenuInteractor
    weak private var  ui: IMenuView?

    init(router: IMenuRouter, interactor: IMenuInteractor) {
        self.router = router
        self.interactor = interactor
    }
}

extension MenuPresenter: IMenuPresenter {
    func viewDidLoad(ui: IMenuView) {
        self.ui = ui
        self.ui?.cellTapped = { [weak self] indexPath in
            self?.interactor.cellTapped(indexPath: indexPath)
        }
        self.interactor.loadFoodForPlace()
    }
}

extension MenuPresenter: IMenuPresenterOuter {
    func passFoodArrayToView(foodArray: [Food]) {
        self.ui?.setupCollectionView(withFoodArray: foodArray)
    }

    func goToOneFoodVC(withFood food: Food) {
        self.router.showFoodVC(withFood: food)
    }
    
    func alertOccured(stringError: String) {
        self.router.showAlertWithMessage(stringError)
    }
}
