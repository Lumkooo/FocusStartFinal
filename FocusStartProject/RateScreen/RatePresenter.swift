//
//  RatePresenter.swift
//  FocusStartProject
//
//  Created by Андрей Шамин on 12/26/20.
//

import Foundation

protocol IRatePresenter {
    func viewDidLoad(ui: IRateView)
}

final class RatePresenter {
    private weak var ui: IRateView?
    private let interactor: IRateInteractor
    private let router: IRateRouter

    init(interactor: IRateInteractor, router: IRateRouter) {
        self.interactor = interactor
        self.router = router
    }
}

// MARK: IRatePresenter

extension RatePresenter: IRatePresenter {
    func viewDidLoad(ui: IRateView) {
        self.ui = ui

        self.interactor.loadInitData()
    }
}

// MARK: - IRateInteractorOuter

extension RatePresenter: IRateInteractorOuter {

}
