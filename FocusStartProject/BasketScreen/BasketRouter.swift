//
//  BasketRouter.swift
//  FocusStartProject
//
//  Created by Андрей Шамин on 12/8/20.
//

import UIKit

protocol IBasketRouter {
    func showAlertWithMessage(_ message: String)
    func showFoodVC(withFood food: Food)
    func showPurchasingVC(foodArray: [Food])
}

final class BasketRouter {
    weak var vc: UIViewController?
}

// MARK: - IBasketRouter

extension BasketRouter: IBasketRouter {
    func showAlertWithMessage(_ message: String) {
        let alert = AlertAssembly.createSimpleAlert(withMessage: message)
        self.vc?.navigationController?.present(alert, animated: true)
    }

    func showFoodVC(withFood food: Food) {
        let oneFoodVC = OneFoodVCAssembly.createVC(withFood: food, vcFor: .basketVC)
        oneFoodVC.modalPresentationStyle = .overFullScreen
        self.vc?.navigationController?.present(oneFoodVC, animated: false)
    }

    func showPurchasingVC(foodArray: [Food]) {
        let purchasingVC = PurchasingVCAssembly.createVC(foodArray: foodArray)
        self.vc?.navigationController?.pushViewController(purchasingVC,
                                                          animated: true)
    }
}
