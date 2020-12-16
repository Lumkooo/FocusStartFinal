//
//  RegisterVCAssembly.swift
//  FocusStartProject
//
//  Created by Андрей Шамин on 12/7/20.
//

import UIKit

enum RegisterVCAssembly {
    static func createVC(delegate: ProfileDelegate) -> UIViewController {
        let registerInteractor = RegisterInteractor(delegate: delegate)
        let registerRouter = RegisterRouter()
        let registerPresenter = RegisterPresenter(interactor: registerInteractor,
                                                  router: registerRouter)
        let registerViewController = RegisterViewController(presenter: registerPresenter)

        registerRouter.vc = registerViewController
        registerInteractor.presenter = registerPresenter
        
        return registerViewController
    }
}
