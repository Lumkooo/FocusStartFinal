//
//  MenuVCAssemby.swift
//  FocusStartProject
//
//  Created by Андрей Шамин on 12/7/20.
//

import UIKit

enum MenuVCAssemby {
    static func createaMenuVC(withPlace place: Place) -> UIViewController {
        let router = MenuRouter()
        let interactor = MenuInteractor(place: place)
        let presenter = MenuPresenter(router: router, interactor: interactor)
        let menuVC = MenuViewController(presenter: presenter)
        interactor.presenter = presenter
        router.vc = menuVC
        return menuVC
    }
}
