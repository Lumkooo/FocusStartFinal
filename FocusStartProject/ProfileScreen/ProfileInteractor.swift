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
    func setupViewForAuthorizedUser(userEmail: String, previousOrders: [HistoryOrderEntity])
    func setupViewForUnauthorizedUser()
    func alertOccured(stringError: String)
}

final class ProfileInteractor {

    // MARK: - Properties

    private var firebaseAuthManager = FirebaseAuthManager()
    private var firebaseDatabaseManager = FirebaseDatabaseManager()
    weak var presenter: IProfileInteractorOuter?
}

// MARK: - IProfileInteractor

extension ProfileInteractor: IProfileInteractor {
    func prepareView() {
        self.setupView()
    }

    func logout() {
        firebaseAuthManager.logout {
            self.setupView()
        } errorCompletion: { (error) in
            self.presenter?.alertOccured(stringError: error.localizedDescription)
        }
    }
}

private extension ProfileInteractor {
    func setupView() {
        if firebaseAuthManager.isSignedIn {
            // Показываем view-профиль пользователя
            let userEmail = self.getUserEmail()
            self.getPreviousOrders { previousOrders in
                self.presenter?.setupViewForAuthorizedUser(userEmail: userEmail,
                                                           previousOrders: previousOrders)
            }
        } else {
            // Показываем view с кнопками регистрации/авторизации
            self.presenter?.setupViewForUnauthorizedUser()
        }
    }

    func getUserEmail() -> String {
        return firebaseAuthManager.userEmail
    }

    func getPreviousOrders(completion: @escaping (([HistoryOrderEntity]) -> Void)) {
        self.firebaseDatabaseManager.getOrders { previousOrders in
            completion(previousOrders)
        } errorCompletion: {
            self.presenter?.alertOccured(stringError: "Приносим извинения, не удалось получить список ваших предыдущих заказов")
            completion([])
        }
    }
}

