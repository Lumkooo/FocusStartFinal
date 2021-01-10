//
//  SearchingPresenter.swift
//  FocusStartProject
//
//  Created by Андрей Шамин on 12/14/20.
//

import Foundation

protocol ISearchingPresenter {
    func viewDidLoad(ui: ISearchingView)
    func textSearching(text: String, category: String)
}

final class SearchingPresenter {
    
    // MARK: - Properties
    
    private weak var ui: ISearchingView?
    private var interactor: ISearchingInteractor
    private var router: ISearchingRouter
    
    // MARK: - Init
    
    init(interactor: ISearchingInteractor,
         router: ISearchingRouter) {
        self.interactor = interactor
        self.router = router
    }
}

// MARK: - ISearchingPresenter

extension SearchingPresenter: ISearchingPresenter {
    func viewDidLoad(ui: ISearchingView) {
        self.ui = ui
        self.ui?.cellTapped = { [weak self] indexPath in
            self?.interactor.cellTapped(indexPath: indexPath)
        }
        self.interactor.loadInitData()
    }
    
    func textSearching(text: String,
                       category: String) {
        self.interactor.searchForPlace(withText: text, category: category)
    }
}

// MARK: - ISearchingInteractorOuter

extension SearchingPresenter: ISearchingInteractorOuter {
    func returnFilteredPlaces(places: [Place]) {
        self.ui?.setupTableView(withPlace: places)
    }
    
    func goToOnePlaceVC(place: Place, delegate: ILikedPlacesDelegate) {
        self.router.showOnePlaceVC(place: place, delegate: delegate)
    }
    
    func showAlert(withText text: String) {
        self.router.showAlert(withText: text)
    }
}
