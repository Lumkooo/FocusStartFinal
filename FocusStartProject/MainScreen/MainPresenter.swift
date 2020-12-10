//
//  MainPresenter.swift
//  FocusStartProject
//
//  Created by Андрей Шамин on 12/7/20.
//

import Foundation

protocol IMainPresenter {
    func viewDidLoad(ui:IMainView)
}

final class MainPresenter {
    private weak var ui: IMainView?
    private var router:IMainRouter
    private var interactor:IMainInteractor

    init(interactor: IMainInteractor, router: IMainRouter) {
        self.interactor = interactor
        self.router = router
    }
}

// MARK: - IMainPresenter

extension MainPresenter: IMainPresenter {
    func viewDidLoad(ui: IMainView) {
        self.ui = ui

        self.ui?.cellSelectedWithPlace={[ weak self] indexPath in
            self?.interactor.cellTapped(atIndexPath: indexPath)
        }

        self.interactor.loadInitData()
    }
}

// MARK: - IMainInteractorOuter

extension MainPresenter: IMainInteractorOuter {
    func showOnePlaceVC(withPlace place: Place) {
        self.router.showOnePlaceViewController(withPlace: place)
    }

    func setupPlacesCollectionView(withPlaces places: [Place]) {
        self.ui?.setupPlacesCollectionView(places: places)
    }
}
