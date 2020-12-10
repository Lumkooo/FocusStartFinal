//
//  PurchasingPresenter.swift
//  FocusStartProject
//
//  Created by Андрей Шамин on 12/9/20.
//

import Foundation

protocol IPurchasingPresenter {
    func viewDidLoad(ui: IPurchasingView)
}

final class PurchasingPresenter {
    private weak var ui: IPurchasingView?
    private var interactor: IPurchasingInteractor
    private var router: IPurchasingRouter

    init(interactor: IPurchasingInteractor, router: IPurchasingRouter) {
        self.interactor = interactor
        self.router = router
    }
}

// MARK: - IPurchasingPresenter

extension PurchasingPresenter: IPurchasingPresenter {
    func viewDidLoad(ui: IPurchasingView) {
        self.ui = ui
        self.interactor.loadInitData()
    }
}

// MARK: - IPurchasingInteractorOuter

extension PurchasingPresenter: IPurchasingInteractorOuter {

}
