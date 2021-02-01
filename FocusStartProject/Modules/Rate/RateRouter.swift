//
//  RateRouter.swift
//  FocusStartProject
//
//  Created by Андрей Шамин on 12/26/20.
//

import UIKit

protocol IRateRouter {
    func showAlert(message: String)
    func dismissVC()
}

final class RateRouter {
    weak var vc: UIViewController?
}

// MARK: IRateRouter

extension RateRouter: IRateRouter {
    func showAlert(message: String) {
        let alert = AlertAssembly.createSimpleAlert(withMessage: message)
        self.vc?.navigationController?.present(alert, animated: true)

    }

    func dismissVC() {
        self.vc?.dismiss(animated: true)
    }
}
