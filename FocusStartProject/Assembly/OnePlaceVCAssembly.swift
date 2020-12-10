//
//  OnePlaceVCAssembly.swift
//  FocusStartProject
//
//  Created by Андрей Шамин on 12/7/20.
//

import UIKit

enum OnePlaceVCAssembly {
    static func createOnePlaceVC(withPlace place: Place) -> UIViewController {
        let onePlaceRouter = OnePlaceRouter()
        let onePlaceInteractor = OnePlaceInteractor(place: place)
        let onePlacePresenter = OnePlacePresenter(interactor: onePlaceInteractor,
                                                  router: onePlaceRouter)
        let onePlaceVC = OnePlaceViewController(presenter: onePlacePresenter)
        onePlaceRouter.vc = onePlaceVC
        onePlaceInteractor.presenter = onePlacePresenter
        return onePlaceVC
    }
}
