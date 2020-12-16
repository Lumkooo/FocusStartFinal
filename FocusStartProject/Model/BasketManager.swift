//
//  BasketManager.swift
//  FocusStartProject
//
//  Created by Андрей Шамин on 12/7/20.
//

import Foundation
/// Метод, обращаясь к которому через sharedInstance
/// можно работать со списком заказов,
/// добавленных в корзину
final class BasketManager {

    // MARK: - Properties

    static let sharedInstance = BasketManager()
    private var basketArray: [Food] = []

    var isEmpty: Bool {
        return self.basketArray.isEmpty
    }

    var count: Int {
        return self.basketArray.count
    }

    // MARK: - Methods

    func getBasketArray() -> [Food] {
        return self.basketArray
    }
    
    func appendFoodToBasket(_ food: Food) {
        self.basketArray.append(food)
    }

    func removeAllFood() {
        self.basketArray.removeAll()
    }
}
