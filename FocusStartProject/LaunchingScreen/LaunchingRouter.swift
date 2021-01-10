//
//  LaunchingRouter.swift
//  FocusStartProject
//
//  Created by Андрей Шамин on 12/18/20.
//

import UIKit

protocol  ILaunchingRouter {
    func dismissVC()
}

final class LaunchingRouter {
    weak var vc: UIViewController?
}

// MARK: - ILaunchingRouter

extension LaunchingRouter: ILaunchingRouter {
    func dismissVC() {
        self.vc?.dismiss(animated: false)
    }
}
