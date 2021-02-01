//
//  RateVCAssembly.swift
//  FocusStartProject
//
//  Created by Андрей Шамин on 12/26/20.
//

import UIKit

enum RateVCAssembly {
    static func createVC(forPlace place: Place, ratePlaceDelegate: IRatePlaceDelegate) -> UIViewController{
        let router = RateRouter()
        let interactor = RateInteractor(place: place, ratePlaceDelegate: ratePlaceDelegate)
        let presenter = RatePresenter(interactor: interactor, router: router)
        let viewController =  RateViewController(presenter: presenter)

        router.vc = viewController
        interactor.presenter = presenter

        return viewController
    }
}
