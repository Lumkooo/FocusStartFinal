//
//  MainRouter.swift
//  FocusStartProject
//
//  Created by Андрей Шамин on 12/7/20.
//

import UIKit

protocol IMainRouter {
    func showOnePlaceViewController(withPlace place: Place, delegate: ILikedPlacesDelegate)
    func showSearchVC(delegate: ILikedPlacesDelegate)
    func showAlertWithMessage(_ message: String)
}

final class MainRouter {
    weak var vc: UIViewController?
}

// MARK: - IMainRouter

extension MainRouter: IMainRouter {
    func showOnePlaceViewController(withPlace place: Place,
                                    delegate: ILikedPlacesDelegate) {
        let onePlaceVC = OnePlaceVCAssembly.createVC(withPlace: place,
                                                     delegate: delegate)
        self.vc?.navigationController?.pushViewController(onePlaceVC,
                                                          animated: true)
    }
    
    func showAlertWithMessage(_ message: String) {
        let alert = AlertAssembly.createSimpleAlert(withMessage: message)
        self.vc?.navigationController?.present(alert, animated: true)
    }
    
    func showSearchVC(delegate: ILikedPlacesDelegate) {
        let searchingVC = SearchingVCAssembly.createVC(delegate: delegate)
        self.vc?.navigationController?.pushViewController(searchingVC,
                                                          animated: true)
    }
}
