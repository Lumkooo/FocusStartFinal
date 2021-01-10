//
//  HistoryOrderEntity.swift
//  FocusStartProject
//
//  Created by Андрей Шамин on 12/11/20.
//

import Foundation

// Сущность для заказа, который сохраняется в списке покупок

struct HistoryOrderEntity {
    var time: String
    var food: String
    var from: String
    var newPrice: Double
    var price: Double
    var imageURL: String
}
