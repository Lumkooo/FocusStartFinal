//
//  RatePlacesManager.swift
//  FocusStartProject
//
//  Created by Андрей Шамин on 12/27/20.
//

import Foundation
import Firebase

final class RatePlaceManager {
    // MARK: - Properties

    private var userUID: String {
        guard let userUID = Auth.auth().currentUser?.uid else {
            // Не должно быть ситуации, когда Auth.auth().currentUser?.uid был бы nil,
            // потому что на все экраны, где это используется можно пройти только авторизовавшись
            // однако на всякий случай:
            assertionFailure("Can't take userUID")
            return ""
        }
        return userUID
    }
    private var databaseRef = Database.database().reference()
    private var currentRating: RatingEntity?
    private var sellerName: String

    // MARK: - Init

    init(place: Place) {
        guard let title = place.title,
              let locationName = place.locationName else {
            assertionFailure("oops, error occured")
            fatalError()
        }
        self.sellerName = title + ", " + locationName
        self.getRating { (rating) in
            self.currentRating = rating
        }
    }
}


extension RatePlaceManager {

    // MARK: - Метод добавления рейтинга заведения

    func ratePlace(rate: Int,
                   completion: (RatingEntity) -> Void) {
        let userRef = databaseRef.child("Rating").child(self.sellerName)
        // Загрузка нового рейтинга в Firebase Database
        guard let ratingCount = self.currentRating?.ratingCount,
              let currentRating = self.currentRating?.currentRating else {
            assertionFailure("oops, error")
            return
        }
        let newRating = (currentRating * Double(ratingCount) + Double(rate))/(Double(ratingCount) + 1)
        userRef.setValue(["RatingsCount":ratingCount+1,"CurrentRating":newRating])
        // Сохранение информации о том, что пользователь уже оценил это заведение
        let isRatedAlreadyRef = databaseRef.child(self.userUID).child("isRated").child(self.sellerName)
        isRatedAlreadyRef.setValue(true)
        // Округленный рейтинг
        let roundedRating = Double(round(100*newRating)/100)
        let newRatingEntity = RatingEntity(currentRating: roundedRating,
                                           ratingCount: ratingCount+1)
        completion(newRatingEntity)
    }

    // MARK: - Метод добавления рейтинга заведения

    func getRating(completion: @escaping ((RatingEntity) -> Void)) {
        let userRef = databaseRef.child("Rating").child(self.sellerName)
        userRef.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let array = snapshot.value as? Dictionary<String, Any> else {
                completion(RatingEntity(currentRating: 0, ratingCount: 0))
                return
            }
            guard let ratingCount = array["RatingsCount"] as? Int,
                  let currentRating = array["CurrentRating"] as? Double else {
                completion(RatingEntity(currentRating: 0, ratingCount: 0))
                return
            }
            // Округленный рейтинг
            let roundedRating = Double(round(100*currentRating)/100)
            let rating = RatingEntity(currentRating: roundedRating,
                                      ratingCount: ratingCount)
            self.currentRating = rating
            completion(rating)
        })
    }

    func isRated(completion: @escaping (Bool) -> Void) {
        let isRatedAlreadyRef = databaseRef.child(self.userUID).child("isRated").child(self.sellerName)
        isRatedAlreadyRef.observeSingleEvent(of: .value) { (snapshot) in
            guard let isRated = snapshot.value as? Bool else {
                completion(false)
                return
            }
            completion(isRated)
        }
    }
}
