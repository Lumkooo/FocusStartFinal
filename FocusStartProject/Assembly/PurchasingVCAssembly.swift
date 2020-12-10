//
//  PurchasingVCAssembly.swift
//  FocusStartProject
//
//  Created by Андрей Шамин on 12/9/20.
//

import UIKit

enum PurchasingVCAssembly {
    static func createVC(foodArray: [Food]) -> UIViewController {
        let interactor = PurchasingInteractor(foodArray: foodArray)
        let router = PurchasingRouter()
        let presenter = PurchasingPresenter(interactor: interactor,
                                            router: router)
        let viewController = PurchasingViewController(presenter: presenter)

        interactor.presenter = presenter
        router.vc = viewController

        return viewController
    }
}
