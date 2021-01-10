//
//  RatePlaceVCAssembly.swift
//  FocusStartProject
//
//  Created by Андрей Шамин on 12/14/20.
//

import UIKit

enum SearchingVCAssembly {
    static func createVC(delegate: ILikedPlacesDelegate) -> UIViewController {
        let interactor = SearchingInteractor(delegate: delegate)
        let router =  SearchingRouter()
        let presenter =  SearchingPresenter(interactor: interactor,
                                            router: router)
        let viewController =  SearchingViewController(presenter: presenter)
        
        router.vc = viewController
        interactor.presenter = presenter

        return viewController
    }
}
