//
//  ProfileRouter.swift
//  FocusStartProject
//
//  Created by Андрей Шамин on 12/8/20.
//

import UIKit

protocol IProfileRouter {
    func showRegisterVC(delegate: ProfileDelegate)
    func showLoginVC(delegate: ProfileDelegate)
    func showAlertWithMessage(_ message: String)
    func showOneOrder(order: HistoryOrderEntity)
}

final class ProfileRouter {
    weak var vc: UIViewController?
}

// MARK: - IProfileRouter

extension ProfileRouter: IProfileRouter {
    func showRegisterVC(delegate: ProfileDelegate){
        let registerVC = RegisterVCAssembly.createVC(delegate: delegate)
        self.vc?.navigationController?.pushViewController(registerVC, animated: true)
    }
    
    func showLoginVC(delegate: ProfileDelegate) {
        let loginVC = LoginVCAssembly.createVC(delegate: delegate)
        self.vc?.navigationController?.pushViewController(loginVC, animated: true)
    }
    
    func showAlertWithMessage(_ message: String) {
        let alert = AlertAssembly.createSimpleAlert(withMessage: message)
        self.vc?.navigationController?.present(alert, animated: true)
    }
    
    func showOneOrder(order: HistoryOrderEntity) {
        let oneOrderVC = OneOrderVCAssembly.createVC(order: order)
        self.vc?.navigationController?.present(oneOrderVC, animated: true)
    }
}
