//
//  MapVCAssembly.swift
//  FocusStartProject
//
//  Created by Андрей Шамин on 12/7/20.
//

import UIKit

enum MapVCAssembly {
    static func createVC() -> UIViewController {
        let mapInteractor = MapInteractor()
        let mapRouter = MapRouter()
        let mapPresenter = MapPresenter(interactor: mapInteractor,
                                        router: mapRouter)
        let mapViewController = MapViewController(presenter: mapPresenter)

        mapInteractor.presenter = mapPresenter
        mapRouter.vc = mapViewController
        
        return mapViewController
    }
}
