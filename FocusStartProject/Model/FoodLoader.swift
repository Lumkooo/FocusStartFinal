//
//  FoodLoader.swift
//  FocusStartProject
//
//  Created by Андрей Шамин on 12/7/20.
//

import Foundation

final class FoodLoader {

    static func loadFoodFor(place: Place,
                            completion: @escaping ([Food]) -> Void,
                            errorCompletion: @escaping ((String) -> Void)) {
        DispatchQueue.global(qos: .userInteractive).async {
            guard let fileName = Bundle.main.url(forResource: "Food", withExtension: "json"),
                  let data = try? Data(contentsOf: fileName) else{
                assertionFailure("oops, something went wrong")
                return
            }
            if let parsedResult = try? JSONDecoder().decode(FoodResponse.self, from: data) {
                let foodArray = parsedResult.foodArray
                let foodArrayForPlace = foodArray.filter { $0.placeName == place.title }
                DispatchQueue.main.async {
                    completion(foodArrayForPlace)
                }
            } else {
                errorCompletion("Произошла непредвиденная ошибка")
            }
        }
    }
}
