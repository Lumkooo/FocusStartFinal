//
//  PurchasingInteractor.swift
//  FocusStartProject
//
//  Created by Андрей Шамин on 12/9/20.
//

import Foundation
import MapKit

protocol IPurchasingInteractor {
    func loadInitData()
    func selfPickupChosen()
    func toUserDeliveryChosen()
    func getTimePresentation(forSegmentControlTitle title: String)
    func order(time: String?)
    func showPrice()
}

protocol IPurchasingInteractorOuter: class {
    func setupUserLocationOnUI()
    func setupSelfPickupOnUI()
    func setupTotalPrice(totalPrice: String)
    func errorOccured(errorDecription: String)
    func returnTimePresentation(timePresentation: [String])
    func soonTimeChosen()
    func toTimeChosen()
    func finishPurchasing()
}

final class PurchasingInteractor {
    
    // MARK: - Constants
    
    private enum Constants {
        static let errorDecription = "Мы не можем получить ваше местоположение\nПроверьте доступ приложения FocusStartProject к вашей геолокации в настройках"
        static let selfPickup = "Самовывоз"
        static let soonTime = "Как можно скорее"
        static let wrongTimeTextFieldAlertText = "Время введено неправильно!"
    }
    
    // MARK: - Properties
    
    weak var presenter: IPurchasingInteractorOuter?
    private var foodArray: [Food]
    private var userLocation: CLLocationCoordinate2D?
    private var userLocationManager: UserLocationManager?
    private var firebaseAuthManager = FirebaseAuthManager()
    private var delegate: IBasketScreenDelegate
    private var timePresentation: [String] = ["Как можно скорее", "Ко времени"]
    private var chosenTime: String?
    private var chosenDeliveryMethod: String?
    private var stringUserLocation: String?

    // MARK: - Init
    
    init(delegate: IBasketScreenDelegate) {
        self.foodArray = BasketManager.sharedInstance.getBasketArray()
        self.delegate = delegate
    }
}

// MARK: - IPurchasingInteractor

extension PurchasingInteractor: IPurchasingInteractor {
    func order(time: String?) {
        if !self.firebaseAuthManager.isSignedIn {
            self.presenter?.errorOccured(errorDecription: "Для оформления заказа необходимо авторизоваться")
            return
        }
        if self.foodArray.isEmpty {
            self.presenter?.errorOccured(errorDecription: "Для оформления заказа необходимо что-то добавить в корзину")
            return
        }
        if var time = time, time.count > 0 {
            if checkTime(&time) == false {
                return
            }
            self.chosenTime = time.applyPatternOnNumbers(pattern: "##:##", replacmentCharacter: "#")
        } else {
            if let _ = chosenTime {
                // Время было выбрано "Как можно скорее", ничего делать не надо
            } else {
                // Время не было выбрано, надо показать ошибку
                self.presenter?.errorOccured(errorDecription: Constants.wrongTimeTextFieldAlertText)
                return
            }
        }
        guard let chosenTime = self.chosenTime else {
            self.presenter?.errorOccured(errorDecription: "Необходимо указать время заказа")
            return
        }
        guard let chosenDeliveryMethod = self.chosenDeliveryMethod else {
            self.presenter?.errorOccured(errorDecription: "Необходимо выбрать способ получения заказа")
            return
        }
        
        // Загрузка списка покупок в Firebase Database
        FirebaseDatabaseManager().uploadOrders(foodArray: self.foodArray,
                                               orderTime: chosenTime,
                                               deliveryMethod: chosenDeliveryMethod) {
            BasketManager.sharedInstance.removeAllFood()
            self.delegate.reloadViewAfterPurchasing()
            NotificationCenter.default.post(
                name: NSNotification.Name(
                    rawValue: AppConstants.NotificationNames.refreshProfileTableView),
                object: nil)
        } errorCompletion: {
            self.presenter?.errorOccured(errorDecription: "Не удалось разместить заказ")
        }
        self.presenter?.finishPurchasing()
    }
    
    func loadInitData() {
        self.getUserLocation()
        self.presenter?.returnTimePresentation(timePresentation: self.timePresentation)
    }
    
    func showPrice() {
        self.foodArray = BasketManager.sharedInstance.getBasketArray()
        let totalPrice = self.getTotalPrice()
        self.presenter?.setupTotalPrice(totalPrice: totalPrice)
    }
    
    func selfPickupChosen() {
        self.selfPickupSetup()
    }
    
    func toUserDeliveryChosen() {
        if let stringUserLocation = self.stringUserLocation {
            self.deliverySetup(stringLocation: stringUserLocation)
        } else {
            self.presenter?.errorOccured(errorDecription: Constants.errorDecription)
        }
    }
    
    func getTimePresentation(forSegmentControlTitle title: String) {
        if title == self.timePresentation[0] {
            // title == Как можно скорее, не надо показывать TextField
            self.chosenTime = Constants.soonTime
            self.presenter?.soonTimeChosen()
        } else if title == self.timePresentation[1] {
            // title == Ко времени, надо показать TextField
            self.chosenTime = nil
            self.presenter?.toTimeChosen()
        }
    }
}

private extension PurchasingInteractor {
    func getUserLocation() {
        self.userLocationManager = UserLocationManager(delegate: self)
    }
    
    func selfPickupSetup() {
        self.chosenDeliveryMethod = Constants.selfPickup
        self.presenter?.setupSelfPickupOnUI()
    }
    
    func deliverySetup(stringLocation: String) {
        self.chosenDeliveryMethod = stringLocation
        self.presenter?.setupUserLocationOnUI()
    }
    
    func getTotalPrice() -> String{
        var totalPrice: Double = 0
        for food in foodArray {
            if let price = food.newFoodPrice {
                totalPrice += price
            }
        }
        return String(totalPrice)
    }
    
    func checkTime(_ time: inout String) -> Bool {
        // Время было введено в TextField-е, назначаем его как выбраное время для дальнейшей работы,
        // если оно удовлетворяет правилам
        time.removeAll { $0 == ":" }
        if time.count < 4 {
            self.presenter?.errorOccured(errorDecription: "Время должно состоять из 4 цифр")
            return false
        }
        let stringMinutes = time.suffix(2)
        let stringHours = time.prefix(2)
        if let hours = Int(stringHours),
           let minutes = Int(stringMinutes) {
            if hours > 23 {
                self.presenter?.errorOccured(errorDecription: "Количество часов и минут не должно превышать 23:59.\n(Если хотите заказать на полночь, то необходимо написать 00:00")
                return false
            } else if minutes > 59 {
                // Проверка, если символ, обозначающий десятки минут, больше 5
                // Время пишется как 9:00, а не 5:60, поэтому if > 5
                self.presenter?.errorOccured(errorDecription: "В одном часе не может быть более 59 минут!")
                return false
            }
        }
        return true
    }
}

// MARK: - IUserLocationManager

extension PurchasingInteractor: IUserLocationManager {
    func locationIsEnabled(location: CLLocationCoordinate2D) {
        // Если мы получили местоположение пользователя, то при загрузке UI
        // устанавливаем место доставки как к пользователю,а не самовывоз
        self.userLocation = location
        GeodecoderManager.decodeAddress(location: location) { (stringLocation) in
            self.stringUserLocation = stringLocation
            self.deliverySetup(stringLocation: stringLocation)
        } errorCompletion: { (errorDescription) in
            // Если не удалось получить местоположение пользователя, то методом доставки
            // выставляем самовывоз
            self.presenter?.setupSelfPickupOnUI()
        }
    }
    
    func locationIsnotEnabled() {
        // в этом случае устанавливаем самовывоз
        self.selfPickupSetup()
    }
}
