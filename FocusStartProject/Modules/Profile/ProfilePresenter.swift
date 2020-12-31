//
//  ProfilePresenter.swift
//  FocusStartProject
//
//  Created by Андрей Шамин on 12/8/20.
//

import Foundation

protocol IProfilePresenter {
    func viewDidLoad(ui: IProfileView)
}

protocol ProfileDelegate {
    func reloadView()
}

final class ProfilePresenter {
    
    // MARK: - Properties
    
    private weak var ui: IProfileView?
    private var router: IProfileRouter
    private var interactor: IProfileInteractor
    
    // MARK: - Init
    
    init(interactor: IProfileInteractor,
         router: IProfileRouter) {
        self.interactor = interactor
        self.router = router
    }
}

// MARK: - IProfilePresenter

extension ProfilePresenter: IProfilePresenter {
    func viewDidLoad(ui: IProfileView) {
        self.ui = ui
        self.ui?.loginTapped = { [weak self] in
            // Избавляюсь от опционала для того, чтобы передать self как
            // ProfileDelegate, а не опционал
            guard let self = self else {
                return
            }
            self.router.showLoginVC(delegate: self)
        }
        self.ui?.registerTapped = { [weak self] in
            // Избавляюсь от опционала для того, чтобы передать self как
            // ProfileDelegate, а не опционал
            guard let self = self else {
                return
            }
            self.router.showRegisterVC(delegate: self)
        }
        self.ui?.logoutTapped = { [weak self] in
            self?.interactor.logout()
        }
        self.ui?.cellTapped = { [weak self] indexPath in
            self?.interactor.retrieveOrder(forIndexPath: indexPath)
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
    
    func reloadTableViewWithData(previousOrders: [HistoryOrderEntity]) {
        self.ui?.reloadTableViewWithData(previousOrders: previousOrders)
    }
    
    func passOrderToRouter(order: HistoryOrderEntity) {
        self.router.showOneOrder(order: order)
    }
}

// MARK: - ProfileDelegate

extension ProfilePresenter: ProfileDelegate {
    // "Перезагрузка" внешнего вида View после регистрации/авторизации
    func reloadView() {
        self.interactor.prepareView()
    }
}
