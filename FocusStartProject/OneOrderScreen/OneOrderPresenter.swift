//
//  OneOrderPresenter.swift
//  FocusStartProject
//
//  Created by Андрей Шамин on 12/12/20.
//

import UIKit

protocol IOneOrderPresenter {
    func viewDidLoad(ui: IOneOrderView)
}

final class OneOrderPresenter {
    
    // MARK: - Properties
    
    private weak var ui: IOneOrderView?
    private var interactor: IOneOrderInteractor
    private var router: IOneOrderRouter
    
    // MARK: - Init
    
    init(interactor: IOneOrderInteractor,
         router: IOneOrderRouter) {
        self.interactor = interactor
        self.router = router
    }
}

// MARK: - IOneOrderPresenter

extension OneOrderPresenter: IOneOrderPresenter {
    func viewDidLoad(ui: IOneOrderView){
        self.ui = ui
        self.interactor.prepareInitData()
    }
}

// MARK: - IOneOrderInteractorOuter

extension OneOrderPresenter: IOneOrderInteractorOuter {
    func setupUIFor(order: HistoryOrderEntity, foodImage: UIImage) {
        self.ui?.setupUIFor(order: order, foodImage: foodImage)
    }
    
    func errorOccured(errorDescription: String) {
        self.router.showAlert(message: errorDescription)
    }
    
    func setupUIFor(order: HistoryOrderEntity) {
        self.ui?.setupUIFor(order: order)
    }
}
