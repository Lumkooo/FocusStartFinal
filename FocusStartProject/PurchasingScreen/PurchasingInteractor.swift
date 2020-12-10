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
}

protocol IPurchasingInteractorOuter: class {

}

final class PurchasingInteractor {

    // MARK: - Properties

    weak var presenter: IPurchasingInteractorOuter?
    private var foodArray: [Food]
    private var userLocation: CLLocationCoordinate2D?
    private var userLocationManager: UserLocationManager?

    // MARK: - Init

    init(foodArray: [Food]) {
        self.foodArray = foodArray
    }
}

// MARK: - IPurchasingInteractor

extension PurchasingInteractor: IPurchasingInteractor {
    func loadInitData() {
        self.getUserLocation()
    }
}


private extension PurchasingInteractor {
    func getUserLocation() {
        self.userLocationManager = UserLocationManager(delegate: self)
    }
}

extension PurchasingInteractor: IUserLocationManager {
    func returnUserLocation(location: CLLocationCoordinate2D) {
        // Если мы получили местоположение пользователя, то при загрузке UI
        // устанавливаем место доставки как к пользователю
        // а не самовывоз
        // Также создать класс декодера location-а в адресс
        print(location)
        self.userLocation = location
//        self.presenter?.setupUserLocation(withLocation: location)
    }

    func locationIsnotEnabled() {
        // в этом случае устанавливаем самовывоз
    }
}
