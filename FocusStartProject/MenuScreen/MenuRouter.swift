//
//  MenuRouter.swift
//  FocusStartProject
//
//  Created by Андрей Шамин on 12/8/20.
//

import UIKit

protocol IMenuRouter {
    func showFoodVC(withFood food: Food)
    func showAlertWithMessage(_ message: String)
}

final class MenuRouter {
    weak var vc: UIViewController?
}

// MARK: - IMenuRouter

extension MenuRouter: IMenuRouter {
    func showFoodVC(withFood food: Food) {
        let oneFoodVC = OneFoodVCAssembly.createVC(withFood: food, vcFor: .menuVC)
        oneFoodVC.modalPresentationStyle = .overFullScreen
        self.vc?.navigationController?.present(oneFoodVC, animated: false)
    }
    
    func showAlertWithMessage(_ message: String) {
        let alert = AlertAssembly.createSimpleAlert(withMessage: message)
        self.vc?.navigationController?.present(alert, animated: true)
    }
}
