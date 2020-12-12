//
//  ProfilePresenter.swift
//  FocusStartProject
//
//  Created by Андрей Шамин on 12/8/20.
//

import Foundation

protocol IProfilePresenter {
    func viewDidLoad(ui:IProfileView)
}

protocol ProfileDelegate {
    func reloadView()
}

final class ProfilePresenter {
    private weak var ui: IProfileView?
    private var router: IProfileRouter
    private var interactor: IProfileInteractor

    init(interactor: IProfileInteractor, router: IProfileRouter) {
        self.interactor = interactor
        self.router = router
    }
}

// MARK: - IProfilePresenter

extension ProfilePresenter: IProfilePresenter {
    func viewDidLoad(ui:IProfileView) {
        self.ui = ui

        self.ui?.loginTapped = { [weak self] in
            guard let self = self else {
                return
            }
            self.router.showLoginVC(delegate: self)
        }

        self.ui?.registerTapped = { [weak self] in
            guard let self = self else {
                return
            }
            self.router.showRegisterVC(delegate: self)
        }

        self.ui?.logoutTapped = { [weak self] in
            self?.interactor.logout()
        }
        self.interactor.prepareView()
    }
}

// MARK: - IProfileInteractorOuter

extension ProfilePresenter: IProfileInteractorOuter {
    func setupViewForAuthorizedUser(userEmail: String, previousOrders: [HistoryOrderEntity]) {
        self.ui?.setupViewForAuthorizedUser(userEmail: userEmail, previousOrders: previousOrders)
    }

    func setupViewForUnauthorizedUser() {
        self.ui?.setupViewForUnauthorizedUser()
    }

    func alertOccured(stringError: String) {
        self.router.showAlertWithMessage(stringError)
    }
}

// MARK: - ProfileDelegate

extension ProfilePresenter: ProfileDelegate {
    func reloadView() {
        self.interactor.prepareView()
    }
}
