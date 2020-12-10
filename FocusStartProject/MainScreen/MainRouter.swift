//
//  MainRouter.swift
//  FocusStartProject
//
//  Created by Андрей Шамин on 12/7/20.
//

import UIKit

protocol IMainRouter {
    func showOnePlaceViewController(withPlace place: Place)
}

final class MainRouter {
    weak var vc: UIViewController?
}

extension MainRouter: IMainRouter {
    func showOnePlaceViewController(withPlace place: Place) {
        let onePlaceVC = OnePlaceVCAssembly.createOnePlaceVC(withPlace: place)
        self.vc?.navigationController?.pushViewController(onePlaceVC,
                                                          animated: true)
    }
}
