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
}

protocol IOnePlaceInteractorOuter: class {
    func setupViewWith(place: Place, placeImage: UIImage)
    func routeToPlace(_ place: Place)
    func menuForPlace(_ place: Place)
}

final class OnePlaceInteractor {
    weak var presenter: IOnePlaceInteractorOuter?
    private var place: Place

    init(place: Place) {
        self.place = place
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
        getImageFor(place: self.place)
    }
}

private extension OnePlaceInteractor {
    func getImageFor(place: Place) {
        guard let imageFile = place.imagefile,
              let imageURL = URL(string: imageFile),
              let placeName = place.title else {
            assertionFailure("Something went wrong")
            return
        }
        ImageCache.loadImage(urlString: imageURL.absoluteString,
                             nameOfPicture: "\(placeName)-logo") { (urlString, image) in
            self.presenter?.setupViewWith(place: self.place,
                                          placeImage: image ?? UIImage())
        }
    }
}
