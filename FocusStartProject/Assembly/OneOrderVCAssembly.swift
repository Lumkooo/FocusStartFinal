//
//  OneOrderVCAssembly.swift
//  FocusStartProject
//
//  Created by Андрей Шамин on 12/12/20.
//

import UIKit

enum OneOrderVCAssembly {
    static func createVC(order: HistoryOrderEntity) -> UIViewController {
        let interactor = OneOrderInteractor(order: order)
        let router = OneOrderRouter()
        let presenter = OneOrderPresenter(interactor: interactor,
                                            router: router)
        let viewController = OneOrderViewContorller(presenter: presenter)

        interactor.presenter = presenter
        router.vc = viewController

        return viewController
    }
}
