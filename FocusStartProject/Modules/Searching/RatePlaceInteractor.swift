//
//  RatePlaceInteractor.swift
//  FocusStartProject
//
//  Created by Андрей Шамин on 12/14/20.
//

import Foundation

protocol IRatePlaceInteractor {
    func loadInitData()
}

protocol IRatePlaceInteractorOuter: class {

}

final class SearchingInteractor {
    weak var presenter: IRatePlaceInteractorOuter?
    private var place: Place
    private var firebaseDatabaseManager = FirebaseDatabaseManager()

    init(place: Place) {
        self.place = place
    }
}

// MARK: - IRatePlaceInteractor

extension SearchingInteractor: IRatePlaceInteractor {
    func loadInitData() {
        
    }
}
