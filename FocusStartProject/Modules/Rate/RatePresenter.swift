//
//  RatePresenter.swift
//  FocusStartProject
//
//  Created by Андрей Шамин on 12/26/20.
//

import Foundation

protocol IRatePresenter {
    func viewDidLoad(ui: IRateView)
}

final class RatePresenter {
    private weak var ui: IRateView?
    private let interactor: IRateInteractor
    private let router: IRateRouter

    init(interactor: IRateInteractor, router: IRateRouter) {
        self.interactor = interactor
        self.router = router
    }
}

// MARK: IRatePresenter

extension RatePresenter: IRatePresenter {
    func viewDidLoad(ui: IRateView) {
        self.ui = ui
        self.ui?.firstButtonTapped = { [weak self] in
            self?.interactor.oneStarTapped()
        }
        self.ui?.secondButtonTapped = { [weak self] in
            self?.interactor.secondStarTapped()
        }
        self.ui?.thirdButtonTapped = { [weak self] in
            self?.interactor.thirdStarTapped()
        }
        self.ui?.fourthButtonTapped = { [weak self] in
            self?.interactor.fourthStarTapped()
        }
        self.ui?.fifthButtonTapped = { [weak self] in
            self?.interactor.fifthStarTapped()
        }
        self.ui?.doneButtonTapped = { [weak self] in
            self?.interactor.ratePlace()
        }
        self.interactor.loadInitData()
    }
}

// MARK: - IRateInteractorOuter

extension RatePresenter: IRateInteractorOuter {
    func setupRating(ratingCount: Int, currentRating: Double) {
        self.ui?.setupRatingLabel(ratingCount: ratingCount,
                                  currentRating: currentRating)
    }

    func errorOccured(errorDescription: String) {
        self.router.showAlert(message: errorDescription)
    }

    func placeRated() {
        self.router.dismissVC()
    }
}
