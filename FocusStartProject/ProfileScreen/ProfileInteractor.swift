//
//  ProfileInteractor.swift
//  FocusStartProject
//
//  Created by Андрей Шамин on 12/8/20.
//

import Foundation

protocol IProfileInteractor {
    func prepareView()
    func logout()
}

protocol IProfileInteractorOuter: class {
    func setupViewForAuthorizedUser(userEmail: String)
    func setupViewForUnauthorizedUser()
    func alertOccured(stringError: String)
}

final class ProfileInteractor {

    // MARK: - Properties

    private var firebaseManager = FirebaseManager()
    weak var presenter: IProfileInteractorOuter?
}

// MARK: - IProfileInteractor

extension ProfileInteractor: IProfileInteractor {
    func prepareView() {
        self.setupView()
    }

    func logout() {
        firebaseManager.logout {
            self.setupView()
        } errorCompletion: { (error) in
            self.presenter?.alertOccured(stringError: error.localizedDescription)
        }
    }
}

private extension ProfileInteractor {
    func setupView() {
        if firebaseManager.isSignedIn {
            // Показываем view-профиль пользователя
            let userEmail = self.getUserEmail()
            self.presenter?.setupViewForAuthorizedUser(userEmail: userEmail)
        } else {
            // Показываем view с кнопками регистрации/авторизации
            self.presenter?.setupViewForUnauthorizedUser()
        }
    }

    func getUserEmail() -> String {
        return firebaseManager.userEmail
    }
}

