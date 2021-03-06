//
//  MainPresenter.swift
//  FocusStartProject
//
//  Created by Андрей Шамин on 12/7/20.
//

import Foundation

protocol IMainPresenter {
    func viewDidLoad(ui: IMainView)
    func searchButtonTapped()
}

final class MainPresenter {
    private weak var ui: IMainView?
    private var router: IMainRouter
    private var interactor: IMainInteractor
    
    init(interactor: IMainInteractor, router: IMainRouter) {
        self.interactor = interactor
        self.router = router
    }
}

// MARK: - IMainPresenter

extension MainPresenter: IMainPresenter {
    func viewDidLoad(ui: IMainView) {
        self.ui = ui
        self.ui?.nearestPlacesCellTapped = {[ weak self] indexPath in
            self?.interactor.nearestPlacesCellTapped(atIndexPath: indexPath)
        }
        self.ui?.likedPlacesCellTapped = {[ weak self] indexPath in
            self?.interactor.likedPlacesCellTapped(atIndexPath: indexPath)
        }
        self.interactor.loadInitData()
    }
    
    func searchButtonTapped() {
        self.interactor.prepareForSearchVC()
    }
}

// MARK: - IMainInteractorOuter

extension MainPresenter: IMainInteractorOuter {
    func showOnePlaceVC(withPlace place: Place,
                        delegate: ILikedPlacesDelegate) {
        self.router.showOnePlaceViewController(withPlace: place,
                                               delegate: delegate)
    }
    
    func setupPlacesCollectionView(withPlaces places: [Place]) {
        self.ui?.setupPlacesCollectionView(places: places)
    }
    
    func errorOccured(errorDescription: String) {
        self.router.showAlertWithMessage(errorDescription)
    }
    
    func setupLikedPlacesCollectionView(withLikedPlaces likedPlaces: [Place]) {
        self.ui?.setupLikedPlacesCollectionView(likedPlaces: likedPlaces)
    }
    
    func prepareForLikedPlaces() {
        self.ui?.prepareForLikedPlaces()
    }
    
    func goToSearchVC(delegate: ILikedPlacesDelegate) {
        self.router.showSearchVC(delegate: delegate)
    }

    func goToNoConnectionVC(delegate: ILostedConnectionDelegate) {
        self.router.showNoConnectionVC(delegate: delegate)
    }
}
