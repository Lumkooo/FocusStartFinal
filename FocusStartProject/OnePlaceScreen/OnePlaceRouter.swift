//
//  OnePlaceRouter.swift
//  FocusStartProject
//
//  Created by Андрей Шамин on 12/7/20.
//

import UIKit

protocol IOnePlaceRouter {
    func showMenuViewController(forPlace place: Place)
    func showRouteAlert(forPlace place: Place)
    func showAlertWithMessage(_ message: String)
    func showRateVC(forPlace place: Place)
}

final class OnePlaceRouter {
    weak var vc: UIViewController?
}

// MARK: - IOnePlaceRouter

extension OnePlaceRouter: IOnePlaceRouter {
    func showMenuViewController(forPlace place: Place) {
        let menuVC = MenuVCAssemby.createaVC(withPlace: place)
        self.vc?.navigationController?.pushViewController(menuVC, animated: true)
    }
    
    func showRouteAlert(forPlace place: Place){
        
        let availableMaps = AvailableMaps.getAvailableMaps(withLocation: place.coordinate)
        
        let alert = UIAlertController(title: "Выберите",
                                      message: "Выберите приложение для построения маршрута",
                                      preferredStyle: .actionSheet)
        for app in availableMaps {
            let button = UIAlertAction(title: app.0, style: .default, handler: { _ in
                UIApplication.shared.open(app.1, options: [:], completionHandler: nil)
            })
            alert.addAction(button)
        }
        let cancel = UIAlertAction(title: "Отменить", style: .cancel, handler: nil)
        alert.addAction(cancel)
        self.vc?.navigationController?.present(alert, animated: true)
    }
    
    func showAlertWithMessage(_ message: String) {
        let alert = AlertAssembly.createSimpleAlert(withMessage: message)
        self.vc?.navigationController?.present(alert, animated: true)
    }

    func showRateVC(forPlace place: Place) {
        let rateVC = RateVCAssembly.createVC(forPlace: place)
        self.vc?.navigationController?.present(rateVC, animated: true)
    }
}
