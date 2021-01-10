//
//  OneFoodInteractor.swift
//  FocusStartProject
//
//  Created by Андрей Шамин on 12/8/20.
//

import UIKit

protocol IOneFoodInteractor {

    func getFood()
    func addFoodToBasket()
}

protocol IOneFoodInteractorOuter: class {
    func setupWithFood(_ food: Food,
                       withImage image: UIImage,
                       forVC oneFoodVCType: OneFoodInteractor.OneFoodFor)
    func dismissView()
}

final class OneFoodInteractor {
    // MARK: - OneFoodFor
    // Для переиспользования этого модуля для basket и menu VC
    // в menu нужна кнопка добавления в корзину,
    // в basket она не нужна
    enum OneFoodFor {
        case basketVC
        case menuVC

        init() {
            self = .menuVC
        }
    }

    // MARK: - Properies

    private var food: Food
    private var oneFoodVCType: OneFoodFor
    weak var presenter: IOneFoodInteractorOuter?

    // MARK: - Init

    init(food: Food,
         vcFor: OneFoodFor) {
        self.food = food
        self.oneFoodVCType = vcFor
    }
}

// MARK: - IOneFoodInteractor

extension OneFoodInteractor: IOneFoodInteractor {
    func getFood() {
        self.loadImage(forFood: self.food) { (image) in
            self.presenter?.setupWithFood(self.food, withImage: image, forVC: self.oneFoodVCType)
        }
    }

    func addFoodToBasket() {
        BasketManager.sharedInstance.appendFoodToBasket(self.food)
        self.presenter?.dismissView()
    }
}



private extension OneFoodInteractor {
    func loadImage(forFood food: Food,
                   completion: @escaping ((UIImage) -> Void)) {
        if let url = food.imageURL {
            ImageCache.loadImage(urlString: url,
                                 nameOfPicture: "\(url)") { (urlString, image) in
                completion(image ?? UIImage())
            }
        } else {
            completion(UIImage())
        }
    }
}
