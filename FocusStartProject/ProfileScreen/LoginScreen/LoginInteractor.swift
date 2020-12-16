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
    
    // MARK: - Properties
    
    weak var presenter: ILoginInteractorOuter?
    private var firebaseAuthManager = FirebaseAuthManager()
    private var delegate: ProfileDelegate
    
    // MARK: - Init
    
    init(delegate: ProfileDelegate) {
        self.delegate = delegate
    }
}

// MARK: - ILoginInteractor

extension LoginInteractor: ILoginInteractor {
    func logIn(loginEntitie: LoginEntitie) {
        firebaseAuthManager.signIn(loginEntitie: loginEntitie) {
            self.presenter?.successfullyLogedIn()
            self.delegate.reloadView()
            NotificationCenter.default.post(name: NSNotification.Name(
                                                rawValue: AppConstants.NotificationNames.refreshLikedPlaces),
                                            object: nil)
        } errorCompletion: { (error) in
            self.presenter?.alertOccured(stringError: error.localizedDescription)
        }
    }
}
