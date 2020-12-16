//
//  RegisterPresenter.swift
//  FocusStartProject
//
//  Created by Андрей Шамин on 12/8/20.
//

import Foundation

protocol IRegisterPresenter {
    func viewDidLoad(ui: IRegisterView)
}

final class RegisterPresenter {
    
    // MARK: - Properties
    
    private  weak var ui: IRegisterView?
    private var router: IRegisterRouter
    private var interactor: IRegisterInteractor
    
    // MARK: - Init
    
    init(interactor: IRegisterInteractor,
         router: IRegisterRouter) {
        self.interactor = interactor
        self.router = router
    }
    
    private func doneTapped(withLogin loginEntitie: LoginEntitie) {
        self.interactor.createUser(loginEntitie: loginEntitie)
    }
}

// MARK: - IRegisterPresenter

extension RegisterPresenter: IRegisterPresenter {
    func viewDidLoad(ui: IRegisterView) {
        self.ui = ui
        
        self.ui?.doneTapped = { [weak self] loginEntitie in
            self?.doneTapped(withLogin: loginEntitie)
        }
        
        self.ui?.textFieldsAlert = { [weak self] alertMessage in
            self?.router.showAlertWithMessage(alertMessage)
        }
    }
}

// MARK: - IRegisterInteractorOuter

extension RegisterPresenter: IRegisterInteractorOuter {
    func alertOccured(stringError: String) {
        self.router.showAlertWithMessage(stringError)
    }
    
    func successfullyRegistered() {
        self.router.popViewController()
    }
}
