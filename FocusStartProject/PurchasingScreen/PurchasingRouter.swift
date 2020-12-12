//
//  PurchasingRouter.swift
//  FocusStartProject
//
//  Created by Андрей Шамин on 12/9/20.
//

import UIKit

protocol IPurchasingRouter {
    func showAlert(errorDecription: String)
    func showFinishPuchasingVC ()
}

final class PurchasingRouter  {
    weak var vc: UIViewController?
}

// MARK: - IPurchasingRouter

extension PurchasingRouter: IPurchasingRouter {
    func showAlert(errorDecription: String) {
        let alert = AlertAssembly.createSimpleAlert(withMessage: errorDecription)
        self.vc?.navigationController?.present(alert, animated: true)
    }

    func showFinishPuchasingVC () {
        let finalPurchasingVC = FinalPurchasingVCAssembly.createVC()
        self.vc?.navigationController?.pushViewController(finalPurchasingVC, animated: true)
    }
}
