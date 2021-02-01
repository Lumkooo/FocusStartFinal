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
    
    // MARK: - Properties
    
    weak var presenter: IRegisterInteractorOuter?
    private let firebaseAuthManager = FirebaseAuthManager()
    private var delegate: ProfileDelegate
    
    // MARK: - Init
    
    init(delegate: ProfileDelegate) {
        self.delegate = delegate
    }
}

// MARK: - IRegisterInteractor

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
