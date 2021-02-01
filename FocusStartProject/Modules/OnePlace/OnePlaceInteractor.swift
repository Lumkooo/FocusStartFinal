//
//  OnePlaceInteractor.swift
//  FocusStartProject
//
//  Created by Андрей Шамин on 12/7/20.
//

import UIKit

protocol IOnePlaceInteractor {
    func takeOnePlace()
    func getRouteToPlace()
    func getMenuForPlace()
    func likeAction()
    func rateAction()
}

protocol IOnePlaceInteractorOuter: class {
    func setupViewWith(place: Place, placeImage: UIImage)
    func setupLikeButton(isLiked: Bool)
    func errorOccured(errorDecription: String)
    func routeToPlace(_ place: Place)
    func menuForPlace(_ place: Place)
    func showDoneView(_ isLiked: Bool)
    func showRateVC(forPlace place: Place, ratePlaceDelegate: IRatePlaceDelegate)
    func setupRatingViews(ratingEntity: RatingEntity)
}

protocol IRatePlaceDelegate: class {
    func reloadRate(ratingEntity: RatingEntity)
}

final class OnePlaceInteractor {
    
    // MARK: - Init
    
    weak var presenter: IOnePlaceInteractorOuter?
    private var firebaseDatabaseManager = FirebaseDatabaseManager()
    private var firebaseAuthManager = FirebaseAuthManager()
    private var ratePlaceManager: RatePlaceManager
    private var place: Place
    private var delegate: ILikedPlacesDelegate?
    private var isLiked: Bool = false {
        didSet {
            self.setupLikeButton()
        }
    }
    
    // MARK: - Properites
    
    init(place: Place,
         delegate: ILikedPlacesDelegate? = nil) {
        self.place = place
        self.delegate = delegate
        self.ratePlaceManager = RatePlaceManager(place: place)
    }
}

// MARK: - IMainInteractor

extension OnePlaceInteractor: IOnePlaceInteractor {
    func getRouteToPlace() {
        self.presenter?.routeToPlace(self.place)
    }
    
    func getMenuForPlace() {
        self.presenter?.menuForPlace(self.place)
    }
    
    func takeOnePlace() {
        self.getImageFor(place: self.place)
        // Кнопку с возможностью добавления места в избранное показывать только, если
        // пользователь авторизован
        if firebaseAuthManager.isSignedIn {
            self.getIsLiked()
            self.getRatingOfPlace()
        }
    }
    
    func likeAction() {
        if self.isLiked {
            // заведение было isLiked => удаляем ее из likedPlaces
            self.removePlaceFromLiked()
        } else {
            // заведение не было isLiked => добавляем ее в likedPlaces
            self.apendPlaceToLiked()
        }
    }

    /// Проверяет поставил ли пользователь оценку заведению или нет.
    /// Если поставил, то показывается alert, если не ставил, то переходит к экрану с возможностью оценить заведение
    func rateAction() {
        self.ratePlaceManager.isRated { (isRated) in
            if isRated {
                self.presenter?.errorOccured(errorDecription: "Вы уже ставили оценку этому заведению")
            } else {
                self.presenter?.showRateVC(forPlace: self.place, ratePlaceDelegate: self)
            }
        }
    }
}

private extension OnePlaceInteractor {
    func getImageFor(place: Place) {
        guard let imageFile = place.imagefile,
              let imageURL = URL(string: imageFile) else {
            assertionFailure("Something went wrong")
            return
        }
        ImageCache.loadImage(urlString: imageURL.absoluteString,
                             nameOfPicture: "\(imageURL.absoluteString)-logo") { (urlString, image) in
            self.presenter?.setupViewWith(place: self.place,
                                          placeImage: image ?? AppConstants.Images.errorImage!)
        }
    }
    
    func apendPlaceToLiked() {
        firebaseDatabaseManager.appendToLikedPlaces(place: self.place) {
            self.isLiked = true
            self.delegate?.placeAddedToLiked(place: self.place)
            self.presenter?.showDoneView(self.isLiked)
        } errorCompletion: {
            self.presenter?.errorOccured(errorDecription: "Не удалось добавить это заведение в избранные")
        }
    }
    
    func removePlaceFromLiked() {
        firebaseDatabaseManager.deleteLikedPlace(place: self.place) {
            self.isLiked = false
            self.delegate?.placeRemovedFromLiked(place: self.place)
            self.presenter?.showDoneView(self.isLiked)
        } errorCompletion: {
            self.presenter?.errorOccured(errorDecription: "Не удалось удалить это заведение из избранных")
        }
    }
    
    func setupLikeButton() {
        self.presenter?.setupLikeButton(isLiked: self.isLiked)
    }
    
    func getIsLiked() {
        self.firebaseDatabaseManager.isPlaceLiked(place: self.place) { (isLiked) in
            self.isLiked = isLiked
        } errorCompletion: {
            self.presenter?.errorOccured(errorDecription: "Не удалось получить информацию о том добавлено ли это заведение в избранные")
        }
    }

    func getRatingOfPlace() {
        self.ratePlaceManager.getRating { (rating) in
            self.presenter?.setupRatingViews(ratingEntity: rating)
        }
    }
}


extension OnePlaceInteractor: IRatePlaceDelegate {
    // Перезагрузка рейтинга после выставления оценки
    func reloadRate(ratingEntity: RatingEntity) {
        self.presenter?.setupRatingViews(ratingEntity: ratingEntity)
    }
}
