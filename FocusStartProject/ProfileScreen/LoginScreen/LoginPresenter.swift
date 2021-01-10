//
//  LoginPresenter.swift
//  FocusStartProject
//
//  Created by Андрей Шамин on 12/8/20.
//

import Foundation

protocol ILoginPresenter {
    func viewDidLoad(ui: ILoginView)
}

final class LoginPresenter {
    
    // MARK: - Properties
    
    private weak var ui: ILoginView?
    private var router: ILoginRouter
    private var interactor: ILoginInteractor
    
    // MARK: - Init
    
    init(interactor: ILoginInteractor,
         router: ILoginRouter) {
        self.interactor = interactor
        self.router = router
    }
    
    private func doneTapped(withLogin loginEntitie: LoginEntitie) {
        self.interactor.logIn(loginEntitie: loginEntitie)
    }
}

// MARK: - ILoginPresenter

extension LoginPresenter: ILoginPresenter {
    func viewDidLoad(ui: ILoginView) {
        self.ui = ui
        self.ui?.doneTapped = { [weak self] loginEntitie in
            self?.doneTapped(withLogin: loginEntitie)
        }
        self.ui?.textFieldsAlert = { [weak self] alertMessage in
            self?.router.showAlertWithMessage(alertMessage)
        }
    }
}

// MARK: - ILoginInteractorOuter

extension LoginPresenter: ILoginInteractorOuter {
    func alertOccured(stringError: String) {
        self.router.showAlertWithMessage(stringError)
    }
    
    func successfullyLogedIn() {
        self.router.popViewController()
    }
}
