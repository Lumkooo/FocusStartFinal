//
//  OneFoodRouter.swift
//  FocusStartProject
//
//  Created by Андрей Шамин on 12/8/20.
//

import UIKit

protocol IOneFoodRouter {
    func dismissView()
}

final class OneFoodRouter {
    weak var vc: UIViewController?
}

extension OneFoodRouter: IOneFoodRouter {
    func dismissView() {
        self.vc?.dismiss(animated: false)
    }
}
