//
//  OneFoodPresenter.swift
//  FocusStartProject
//
//  Created by Андрей Шамин on 12/8/20.
//

import UIKit

protocol IOneFoodPresenter {
    func viewDidLoad(ui: IOneFoodView)
}

final class OneFoodPresenter {
    
    // MARK: - Properties
    
    weak private var ui: IOneFoodView?
    private var router: IOneFoodRouter
    private var interactor: IOneFoodInteractor
    
    // MARK: - Init
    
    init(router: IOneFoodRouter,
         interactor: IOneFoodInteractor) {
        self.router = router
        self.interactor = interactor
    }
}

// MARK: - IOneFoodPresenter

extension OneFoodPresenter: IOneFoodPresenter {
    func viewDidLoad(ui: IOneFoodView) {
        self.ui = ui
        self.ui?.closeButtonTapped = { [weak self] in
            self?.router.dismissView()
        }
        self.ui?.addFoodButtonTapped = { [weak self] in
            self?.interactor.addFoodToBasket()
        }
        self.interactor.getFood()
    }
}

// MARK: - IOneFoodInteractorOuter

extension OneFoodPresenter: IOneFoodInteractorOuter {
    func setupWithFood(_ food: Food,
                       withImage image: UIImage,
                       forVC oneFoodVCType: OneFoodInteractor.OneFoodFor) {
        self.ui?.setupViewWithFood(food,
                                   withImage: image,
                                   forVC: oneFoodVCType)
    }
    
    func dismissView() {
        self.router.dismissView()
    }
}
