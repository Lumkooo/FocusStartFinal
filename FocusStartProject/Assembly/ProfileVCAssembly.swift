//
//  ProfileVCAssembly.swift
//  FocusStartProject
//
//  Created by Андрей Шамин on 12/7/20.
//

import UIKit

enum ProfileVCAssembly {
    static func createProfileVC() -> UIViewController {
        let profileRouter = ProfileRouter()
        let profileInteractor = ProfileInteractor()
        let profilePresenter = ProfilePresenter(interactor: profileInteractor, router: profileRouter)
        let profileVC = ProfileViewController(presenter: profilePresenter)
        profileRouter.vc = profileVC
        profileInteractor.presenter = profilePresenter
        return profileVC
    }
}
