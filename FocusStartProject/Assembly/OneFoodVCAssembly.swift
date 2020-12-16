//
//  OneFoodVCAssembly.swift
//  FocusStartProject
//
//  Created by Андрей Шамин on 12/7/20.
//

import UIKit

enum OneFoodVCAssembly {
    static func createVC(withFood food: Food,
                         vcFor: OneFoodInteractor.OneFoodFor) -> UIViewController {
        let router = OneFoodRouter()
        let interactor = OneFoodInteractor(food: food,
                                           vcFor: vcFor)
        let presenter = OneFoodPresenter(router: router,
                                         interactor: interactor)
        let viewController = OneFoodViewController(presenter: presenter)

        interactor.presenter = presenter
        router.vc = viewController

        return viewController
    }
}
