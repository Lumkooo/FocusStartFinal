//
//  BasketManager.swift
//  FocusStartProject
//
//  Created by Андрей Шамин on 12/7/20.
//

import Foundation

final class BasketManager {
    static let sharedInstance = BasketManager()
    private var basketArray: [Food] = []
    
    func getBasketArray() -> [Food] {
        return self.basketArray
    }
    
    func appendFoodToBasket(_ food: Food) {
        self.basketArray.append(food)
    }
    
    var isEmpty: Bool {
        return self.basketArray.isEmpty
    }
    
    var count: Int {
        return self.basketArray.count
    }
    
    func removeAllFood() {
        self.basketArray.removeAll()
    }
}
