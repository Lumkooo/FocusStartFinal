//
//  RateInteractor.swift
//  FocusStartProject
//
//  Created by Андрей Шамин on 12/26/20.
//

import Foundation

protocol IRateInteractor {
    func loadInitData()
}

protocol IRateInteractorOuter: class {

}

final class RateInteractor {

    private let place: Place
    weak var presenter: IRateInteractorOuter?

    init(place: Place){
        self.place = place
    }
}

// MARK: IRateInteractor

extension RateInteractor: IRateInteractor {
    func loadInitData() {
        
    }
}
