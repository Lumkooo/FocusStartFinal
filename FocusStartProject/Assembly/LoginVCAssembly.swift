//
//  LoginVCAssembly.swift
//  FocusStartProject
//
//  Created by Андрей Шамин on 12/7/20.
//

import UIKit

enum LoginVCAssembly {
    static func createLoginVC(delegate: ProfileDelegate) -> UIViewController {
        let loginInteractor = LoginInteractor(delegate: delegate)
        let loginRouter = LoginRouter()
        let loginPresenter = LoginPresenter(interactor: loginInteractor, router: loginRouter)
        let loginViewController = LoginViewController(presenter: loginPresenter)

        loginRouter.vc = loginViewController
        loginInteractor.presenter = loginPresenter

        return loginViewController
    }
}
