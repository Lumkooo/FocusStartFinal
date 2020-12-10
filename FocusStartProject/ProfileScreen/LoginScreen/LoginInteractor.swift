//
//  LoginInteractor.swift
//  FocusStartProject
//
//  Created by Андрей Шамин on 12/8/20.
//

import Foundation

protocol ILoginInteractor {
    func logIn(loginEntitie: LoginEntitie)
}

protocol ILoginInteractorOuter: class {
    func alertOccured(stringError: String)
    func successfullyLogedIn()
}

final class LoginInteractor {
    weak var presenter: ILoginInteractorOuter?
    private var firebaseManager = FirebaseManager()
    private var delegate: ProfileDelegate

    init(delegate: ProfileDelegate) {
        self.delegate = delegate
    }
}

extension LoginInteractor: ILoginInteractor {
    func logIn(loginEntitie: LoginEntitie) {
        firebaseManager.signIn(loginEntitie: loginEntitie) {
            self.presenter?.successfullyLogedIn()
            self.delegate.reloadView()
        } errorCompletion: { (error) in
            self.presenter?.alertOccured(stringError: error.localizedDescription)
        }

    }
}
