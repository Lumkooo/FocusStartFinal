//
//  OnePlacePresenter.swift
//  FocusStartProject
//
//  Created by Андрей Шамин on 12/7/20.
//

import UIKit

protocol IOnePlacePresenter {
    func viewDidLoad(ui: IOnePlaceView)
}

final class OnePlacePresenter {

    // MARK: - Properites

    private weak var ui: IOnePlaceView?
    private var router: IOnePlaceRouter
    private var interactor: IOnePlaceInteractor

    // MARK: - Init

    init(interactor: IOnePlaceInteractor,
         router: IOnePlaceRouter) {
        self.interactor = interactor
        self.router = router
    }
}

// MARK: - IOnePlacePresenter

extension OnePlacePresenter: IOnePlacePresenter {
    func viewDidLoad(ui: IOnePlaceView) {
        self.ui = ui
        self.ui?.adressButtonTapped = { [weak self] in
            self?.interactor.getRouteToPlace()
        }
        self.ui?.menuButtonTapped = { [weak self] in
            self?.interactor.getMenuForPlace()
        }
        self.ui?.likeButtonTapped = { [weak self] in
            self?.interactor.likeAction()
        }
        self.ui?.rateButtonTapped = { [weak self] in
            self?.interactor.rateAction()
        }
        self.interactor.takeOnePlace()
    }
}

// MARK: - IOnePlaceInteractorOuter

extension OnePlacePresenter: IOnePlaceInteractorOuter {
    func setupViewWith(place: Place,
                       placeImage: UIImage) {
        self.ui?.setupView(place: place, placeImage: placeImage)
    }
    
    func routeToPlace(_ place: Place) {
        self.router.showRouteAlert(forPlace: place)
    }
    
    func menuForPlace(_ place: Place) {
        self.router.showMenuViewController(forPlace: place)
    }
    
    func setupLikeButton(isLiked: Bool) {
        self.ui?.setupLikeButton(isLiked: isLiked)
    }
    
    func errorOccured(errorDecription: String) {
        self.router.showAlertWithMessage(errorDecription)
    }

    func showDoneView(_ isLiked: Bool) {
        self.ui?.showDoneView(isLiked)
    }

    func showRateVC(forPlace place: Place, ratePlaceDelegate: IRatePlaceDelegate) {
        self.router.showRateVC(forPlace: place, ratePlaceDelegate: ratePlaceDelegate)
    }

    func setupRatingViews(ratingEntity: RatingEntity) {
        self.ui?.setupRatingViews(ratingEntity: ratingEntity)
    }
}
