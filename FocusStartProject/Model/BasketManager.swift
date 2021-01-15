//
//  BasketManager.swift
//  FocusStartProject
//
//  Created by Андрей Шамин on 12/7/20.
//

import Foundation

private protocol IBasketManager {
    var basketArray: [Food] { get }
    var isEmpty: Bool { get }
    var count: Int { get }

    func getBasketArray() -> [Food]
    func appendFoodToBasket(_ food: Food)
    func removeAllFood()
}

/// Метод, обращаясь к которому через sharedInstance
/// можно работать со списком заказов,
/// добавленных в корзину
final class BasketManager: IBasketManager {

    // MARK: - Properties

    static let sharedInstance = BasketManager()
    fileprivate var basketArray: [Food] = []

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
