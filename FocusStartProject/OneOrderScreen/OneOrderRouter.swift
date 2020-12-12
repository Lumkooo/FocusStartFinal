//
//  OneOrderRouter.swift
//  FocusStartProject
//
//  Created by Андрей Шамин on 12/12/20.
//

import UIKit

protocol IOneOrderRouter {
    func showAlert(message: String)
}

final class OneOrderRouter {
    weak var vc: UIViewController?
}

// MARK: - IOneOrderRouter

extension OneOrderRouter: IOneOrderRouter {
    func showAlert(message: String) {
        let alert = AlertAssembly.createSimpleAlert(withMessage: message)
        self.vc?.navigationController?.present(alert, animated: true)
    }
}
