//
//  LaunchingPresenter.swift
//  FocusStartProject
//
//  Created by Андрей Шамин on 12/18/20.
//

import Foundation

protocol  ILaunchingPresenter {
    func viewDidLoad(ui: ILaunchingView)
    func viewDidAppear()
}

final class LaunchingPresenter {

    // MARK: - Properties
    private weak var ui: ILaunchingView?
    private var router: ILaunchingRouter

    // MARK: - Init

    init(router: ILaunchingRouter) {
        self.router = router
    }
}

// MARK: - ILaunchingPresenter

extension LaunchingPresenter: ILaunchingPresenter {
    func viewDidLoad(ui: ILaunchingView) {
        self.ui = ui
        self.ui?.launched = { [weak self] in
            self?.router.dismissVC()
        }
        self.ui?.setupElements()
    }

    func viewDidAppear() {
        self.ui?.playLaunchingThing()
    }
}
