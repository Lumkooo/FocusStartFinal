//
//  SearchingRouter.swift
//  FocusStartProject
//
//  Created by Андрей Шамин on 12/14/20.
//

import UIKit

protocol ISearchingRouter {
    func showOnePlaceVC(place: Place, delegate: ILikedPlacesDelegate)
    func showAlert(withText text: String)
}

final class SearchingRouter {
    weak var vc: UIViewController?
}

// MARK: - ISearchingRouter

extension SearchingRouter: ISearchingRouter {
    func showOnePlaceVC(place: Place, delegate: ILikedPlacesDelegate) {
        let onePlaceVC = OnePlaceVCAssembly.createVC(withPlace: place, delegate: delegate)
        self.vc?.navigationController?.pushViewController(onePlaceVC,
                                                          animated: true)
    }
    
    func showAlert(withText text: String) {
        let alert = AlertAssembly.createSimpleAlert(withMessage: text)
        self.vc?.navigationController?.present(alert, animated: true)
    }
}
