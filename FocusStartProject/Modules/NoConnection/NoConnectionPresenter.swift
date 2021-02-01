//
//  NoConnectionPresenter.swift
//  FocusStartProject
//
//  Created by Андрей Шамин on 12/18/20.
//

import Foundation

protocol INoConnectionPresenter {
    func viewDidLoad(ui: INoConnectionView)
}

final class NoConnectionPresenter {

    // MARK: - Properties

    private weak var ui: INoConnectionView?
    private var router: INoConnectionRouter
    private var interactor: INoConnectionInteractor

    // MARK: - Init

    init(router: INoConnectionRouter, interactor: INoConnectionInteractor) {
        self.router = router
        self.interactor = interactor
    }
}

// MARK: - INoConnectionPresenter

extension NoConnectionPresenter: INoConnectionPresenter {
    func viewDidLoad(ui: INoConnectionView) {
        self.ui = ui

        self.ui?.checkConnectionToInternet = { [weak self] in
            self?.interactor.checkConnection()
        }

        self.ui?.connectionEnabled = { [weak self] in
            self?.router.dismissVC()
        }
    }
}

extension NoConnectionPresenter: INoConnectionInteractorOuter {
    func connection(isEnabled: Bool) {
        self.ui?.connection(isConnectionEnabled: isEnabled)
    }
}
