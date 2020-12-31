//
//  RegisterRouter.swift
//  FocusStartProject
//
//  Created by Андрей Шамин on 12/8/20.
//

import UIKit

protocol IRegisterRouter {
    func showAlertWithMessage(_ message: String)
    func popViewController()
}

final class RegisterRouter {
    weak var vc: UIViewController?
}

// MARK: - IRegisterRouter

extension RegisterRouter: IRegisterRouter {
    func showAlertWithMessage(_ message: String) {
        let alert = AlertAssembly.createSimpleAlert(withMessage: message)
        self.vc?.navigationController?.present(alert, animated: true)
    }
    
    func popViewController() {
        self.vc?.navigationController?.popViewController(animated: true)
    }
}
