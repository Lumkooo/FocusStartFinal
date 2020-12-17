//
//  Food.swift
//  FocusStartProject
//
//  Created by Андрей Шамин on 12/7/20.
//

import Foundation

// Еда
struct Food: Decodable {
    let placeName: String?
    let foodName: String?
    let foodPrice: Double?
    let imageURL: String?
    let newFoodPrice: Double?
    var address: String?
    
    enum CodingKeys: String, CodingKey {
        case placeName
        case foodName
        case foodPrice
        case imageURL
        case newFoodPrice
        case address
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.placeName = try? container.decode(String.self, forKey: .placeName)
        self.foodName = try? container.decode(String.self, forKey: .foodName)
        self.foodPrice = try? container.decode(Double.self, forKey: .foodPrice)
        self.imageURL = try? container.decode(String.self, forKey: .imageURL)
        self.newFoodPrice = try? container.decode(Double.self, forKey: .newFoodPrice)
        self.address = try? container.decode(String.self, forKey: .address)
    }
}
