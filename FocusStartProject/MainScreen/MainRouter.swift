//
//  MainRouter.swift
//  FocusStartProject
//
//  Created by Андрей Шамин on 12/7/20.
//

import UIKit

protocol IMainRouter {
    func showOnePlaceViewController(withPlace place: Place, delegate: ILikedPlacesDelegate)
    func showAlertWithMessage(_ message: String)
}

final class MainRouter {
    weak var vc: UIViewController?
}

extension MainRouter: IMainRouter {
    func showOnePlaceViewController(withPlace place: Place, delegate: ILikedPlacesDelegate) {
        let onePlaceVC = OnePlaceVCAssembly.createOnePlaceVC(withPlace: place, delegate: delegate)
        self.vc?.navigationController?.pushViewController(onePlaceVC,
                                                          animated: true)
    }

    func showAlertWithMessage(_ message: String) {
        let alert = AlertAssembly.createSimpleAlert(withMessage: message)
        self.vc?.navigationController?.present(alert, animated: true)
    }
}
