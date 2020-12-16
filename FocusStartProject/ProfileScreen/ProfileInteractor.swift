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
    func retrieveOrder(forIndexPath indexPath: IndexPath)
}

protocol IProfileInteractorOuter: class {
    func setupViewForAuthorizedUser(userEmail: String, previousOrders: [HistoryOrderEntity])
    func reloadTableViewWithData(previousOrders: [HistoryOrderEntity])
    func setupViewForUnauthorizedUser()
    func alertOccured(stringError: String)
    func passOrderToRouter(order: HistoryOrderEntity)
}

final class ProfileInteractor {
    
    // MARK: - Properties
    
    private var firebaseAuthManager = FirebaseAuthManager()
    private var firebaseDatabaseManager = FirebaseDatabaseManager()
    private var previousOrders: [HistoryOrderEntity] = []
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
            NotificationCenter.default.post(name: NSNotification.Name(
                                                rawValue: AppConstants.NotificationNames.refreshLikedPlaces),
                                            object: nil)
        } errorCompletion: { (error) in
            self.presenter?.alertOccured(stringError: error.localizedDescription)
        }
    }
    
    func retrieveOrder(forIndexPath indexPath: IndexPath) {
        let order = self.previousOrders[indexPath.row]
        self.presenter?.passOrderToRouter(order: order)
    }
}

private extension ProfileInteractor {
    func setupView() {
        if firebaseAuthManager.isSignedIn {
            // Показываем view-профиль пользователя
            let userEmail = self.getUserEmail()
            self.getPreviousOrders { previousOrders in
                self.previousOrders = previousOrders
                self.presenter?.setupViewForAuthorizedUser(userEmail: userEmail,
                                                           previousOrders: previousOrders)
            }
            self.setupNotification()
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
    
    func setupNotification() {
        // Вызывается в PurchasingScreen-е для обновления tableView истории заказов после совершения покупки
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(refreshTableViewAfterNewOrders(_:)),
                                               name: NSNotification.Name(
                                                rawValue: AppConstants.NotificationNames.refreshProfileTableView),
                                               object: nil)
    }
    
    
    @objc func refreshTableViewAfterNewOrders(_ notification:Notification) {
        // Для обновления TableView с предыдущими записями раз в секунду обращаемся к БД, чтобы узнать
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            // Берем количество записей в БД
            self.firebaseDatabaseManager.getOrdersCount { (childrenCount) in
                // Сравниваем с количеством имеющихся записей и если количество записей различается
                if self.previousOrders.count != childrenCount {
                    // То берем записи из БД
                    self.getPreviousOrders { previousOrders in
                        timer.invalidate()
                        self.previousOrders = previousOrders
                        self.presenter?.reloadTableViewWithData(previousOrders: previousOrders)
                    }
                }
            }
        }
    }
}

