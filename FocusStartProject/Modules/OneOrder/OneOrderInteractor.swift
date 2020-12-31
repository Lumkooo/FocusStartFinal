//
//  OneOrderInteractor.swift
//  FocusStartProject
//
//  Created by Андрей Шамин on 12/12/20.
//

import UIKit

protocol IOneOrderInteractor {
    func prepareInitData()
}

protocol IOneOrderInteractorOuter: class {
    func setupUIFor(order: HistoryOrderEntity, foodImage: UIImage)
    func setupUIFor(order: HistoryOrderEntity)
    func errorOccured(errorDescription: String)
}


final class OneOrderInteractor {
    
    // MARK: - Properties
    
    weak var presenter: IOneOrderInteractorOuter?
    private var order: HistoryOrderEntity
    
    // MARK: - Init
    
    init(order: HistoryOrderEntity) {
        self.order = order
    }
}

// MARK: - IOneOrderInteractor

extension OneOrderInteractor: IOneOrderInteractor {
    func prepareInitData() {
        ImageCache.loadImage(urlString: self.order.imageURL,
                             nameOfPicture: "\(self.order.imageURL)") { (urlString, image) in
            guard let image = image else {
                self.presenter?.setupUIFor(order: self.order)
                self.presenter?.errorOccured(errorDescription: "Не удается загрузить изображение еды")
                return
            }
            self.presenter?.setupUIFor(order: self.order, foodImage: image)
        }
    }
}
