//
//  RegisterInteractor.swift
//  FocusStartProject
//
//  Created by Андрей Шамин on 12/8/20.
//

import Foundation

protocol IRegisterInteractor {
    func createUser(loginEntitie: LoginEntitie)
}

protocol IRegisterInteractorOuter: class {
    func alertOccured(stringError: String)
    func successfullyRegistered()
}

final class RegisterInteractor {
    weak var presenter: IRegisterInteractorOuter?
    private let firebaseAuthManager = FirebaseAuthManager()
    private var delegate: ProfileDelegate

    init(delegate: ProfileDelegate) {
        self.delegate = delegate
    }
}

extension RegisterInteractor: IRegisterInteractor {
    func createUser(loginEntitie: LoginEntitie) {
        firebaseAuthManager.createUser(loginEntitie: loginEntitie) {
            self.presenter?.successfullyRegistered()
            self.delegate.reloadView()
        } errorCompletion: { (error) in
            self.presenter?.alertOccured(stringError: error.localizedDescription)
        }
    }
}
