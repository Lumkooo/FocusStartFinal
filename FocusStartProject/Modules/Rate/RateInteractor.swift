//
//  RateInteractor.swift
//  FocusStartProject
//
//  Created by Андрей Шамин on 12/26/20.
//

import Foundation

protocol IRateInteractor {
    func loadInitData()
    func oneStarTapped()
    func secondStarTapped()
    func thirdStarTapped()
    func fourthStarTapped()
    func fifthStarTapped()
    func ratePlace()
}

protocol IRateInteractorOuter: class {
    func setupRating(ratingCount: Int, currentRating: Double)
    func errorOccured(errorDescription: String)
    func placeRated()
}

final class RateInteractor {

    // MARK: - Properties

    private var currentRating = 0
    private let place: Place
    weak var presenter: IRateInteractorOuter?
    private let ratePlaceManager: RatePlaceManager
    private var ratePlaceDelegate: IRatePlaceDelegate

    // MARK: - Init

    init(place: Place, ratePlaceDelegate: IRatePlaceDelegate){
        self.place = place
        self.ratePlaceManager = RatePlaceManager(place: place)
        self.ratePlaceDelegate = ratePlaceDelegate
    }
}

// MARK: IRateInteractor

extension RateInteractor: IRateInteractor {
    func loadInitData() {

        self.ratePlaceManager.getRating { (rating) in
            self.presenter?.setupRating(ratingCount: rating.ratingCount,
                                        currentRating: rating.currentRating)

        }
    }

    func oneStarTapped() {
        self.currentRating = 1
    }
    func secondStarTapped() {
        self.currentRating = 2
    }

    func thirdStarTapped() {
        self.currentRating = 3
    }

    func fourthStarTapped() {
        self.currentRating = 4
    }

    func fifthStarTapped() {
        self.currentRating = 5
    }

    func ratePlace() {
        if self.currentRating > 0 {
            ratePlaceManager.ratePlace(rate: self.currentRating) { ratingEntity in
                self.presenter?.placeRated()
                self.ratePlaceDelegate.reloadRate(ratingEntity: ratingEntity)
            }
        } else {
            self.presenter?.errorOccured(errorDescription: "Сначала необходимо какую оценку вы поставите")
        }
    }
}
