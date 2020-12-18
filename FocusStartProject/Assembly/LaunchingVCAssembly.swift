//
//  LaunchingVCAssembly.swift
//  FocusStartProject
//
//  Created by Андрей Шамин on 12/18/20.
//

import UIKit

enum LaunchingVCAssembly {
    static func createVC() -> UIViewController {
        let router =  LaunchingRouter()
        let presenter =  LaunchingPresenter(router: router)
        let viewController =  LaunchingViewController(presenter: presenter)

        router.vc = viewController

        return viewController
    }
}
