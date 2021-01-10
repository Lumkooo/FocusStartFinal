//
//  NoConnectionVCAssembly.swift
//  FocusStartProject
//
//  Created by Андрей Шамин on 12/18/20.
//

import UIKit

enum NoConnectionVCAssembly {
    static func createVC(delegate: ILostedConnectionDelegate) -> UIViewController {
        let router = NoConnectionRouter(delegate: delegate)
        let interactor = NoConnectionInteractor()
        let presenter = NoConnectionPresenter(router: router, interactor: interactor)
        let viewController =  NoConnectionViewController(presenter: presenter)

        router.vc = viewController
        interactor.presenter = presenter

        return viewController
    }
}

