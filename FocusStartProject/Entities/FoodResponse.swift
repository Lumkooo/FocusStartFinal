//
//  FoodResponse.swift
//  FocusStartProject
//
//  Created by Андрей Шамин on 12/7/20.
//

import Foundation

// Сущность для получения списка еды из JSON
struct  FoodResponse: Decodable {
    enum CodingKeys: String, CodingKey {
        case foodArray
    }
    let foodArray: [Food]
}
