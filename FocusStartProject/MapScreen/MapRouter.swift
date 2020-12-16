//
//  MapRouter.swift
//  FocusStartProject
//
//  Created by Андрей Шамин on 12/8/20.
//

import UIKit

protocol IMapRouter {
    func goToOnePlace(_ place: Place)
    func showAlertWithMessage(_ message: String)
}

final class MapRouter {
    weak var vc: UIViewController?
}

// MARK: - IMapRouter

extension MapRouter: IMapRouter {
    func goToOnePlace(_ place: Place) {
        let onePlaceVC = OnePlaceVCAssembly.createVC(withPlace: place)
        self.vc?.navigationController?.pushViewController(onePlaceVC,
                                                          animated: true)
    }

    func showAlertWithMessage(_ message: String) {
        let alert = AlertAssembly.createSimpleAlert(withMessage: message)
        self.vc?.navigationController?.present(alert, animated: true)
    }
}
