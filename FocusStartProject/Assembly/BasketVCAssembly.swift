//
//  BasketVCAssembly.swift
//  FocusStartProject
//
//  Created by Андрей Шамин on 12/7/20.
//

import UIKit

enum BasketVCAssembly {
    static func createVC() -> UIViewController {
        let router = BasketRouter()
        let interactor = BasketInteractor()
        let presenter = BasketPresenter(interactor: interactor,
                                        router: router)
        let viewController = BasketViewController(presenter: presenter)

        router.vc = viewController
        interactor.presenter = presenter

        return viewController
    }
}
