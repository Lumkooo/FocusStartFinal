//
//  NoConnectionRouter.swift
//  FocusStartProject
//
//  Created by Андрей Шамин on 12/18/20.
//

import UIKit

protocol INoConnectionRouter {
    func dismissVC()
}

final class NoConnectionRouter {

    // MARK: - Properties

    weak var vc: UIViewController?
    private let delegate: ILostedConnectionDelegate

    // MARK: - Properties

    init(delegate: ILostedConnectionDelegate) {
        self.delegate = delegate
    }
}

// MARK: - INoConnectionRouter

extension NoConnectionRouter: INoConnectionRouter {
    func dismissVC() {
        self.vc?.dismiss(animated: true)
        self.delegate.reloadDataOnMainScreen()
    }
}
