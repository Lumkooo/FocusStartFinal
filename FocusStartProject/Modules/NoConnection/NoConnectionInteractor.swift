//
//  NoConnectionInteractor.swift
//  FocusStartProject
//
//  Created by Андрей Шамин on 12/18/20.
//

import Foundation


protocol INoConnectionInteractor {
    func checkConnection()
}

protocol INoConnectionInteractorOuter: class {
    func connection(isEnabled: Bool)
}

final class NoConnectionInteractor {

    // MARK: - Properties

    weak var presenter: INoConnectionInteractorOuter?
}

// MARK: - INoConnectionPresenter

extension NoConnectionInteractor: INoConnectionInteractor {
    func checkConnection() {
        let isEnabled = Reachability.isConnectedToNetwork()
        self.presenter?.connection(isEnabled: isEnabled)
    }
}
