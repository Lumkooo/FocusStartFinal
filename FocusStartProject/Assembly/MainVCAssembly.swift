//
//  MainVCAssembly.swift
//  FocusStartProject
//
//  Created by Андрей Шамин on 12/7/20.
//

import UIKit

enum MainVCAssembly {
    static func createMainVC() -> UIViewController {
        let mainInteractor = MainInteractor()
        let mainRouter = MainRouter()
        let mainPresenter = MainPresenter(interactor: mainInteractor, router: mainRouter)
        let mainViewController = MainViewController(presenter: mainPresenter)
        mainRouter.vc = mainViewController
        mainInteractor.presenter = mainPresenter
        return mainViewController
    }
}
