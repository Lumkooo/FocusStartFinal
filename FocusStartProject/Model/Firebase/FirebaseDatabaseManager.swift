//
//  FirebaseDatabaseManager.swift
//  FocusStartProject
//
//  Created by Андрей Шамин on 12/11/20.
//

import Foundation
import Firebase

final class FirebaseDatabaseManager {
    
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
    private var timeManager = TimeManager()
}

// MARK: - Методы для работы с избранными местами

extension FirebaseDatabaseManager {
    
    /// Метод добавляет текущую запись в список понравившихся, сохраняет ее в Firebase Database
    func appendToLikedPlaces(place: Place,
                             completion: @escaping () -> Void,
                             errorCompletion: @escaping () -> Void) {
        guard let title = place.title,
              let locationName = place.locationName else {
            errorCompletion()
            return
        }
        let likedPlace = FirebaseLikedPlace(locationName: locationName,
                                            title: title)
        let likedPlacesRef = databaseRef.child(self.userUID).child("likedPlaces")
        let newRefIndex = ("\(title), \(locationName)")
        likedPlacesRef.child("\(newRefIndex)").setValue(["title" : likedPlace.title,
                                                         "locationName" : likedPlace.locationName])
        completion()
    }
    
    /// Метод удаляет текущую запись из списка понравившихся
    func deleteLikedPlace(place: Place,
                          completion: @escaping () -> Void,
                          errorCompletion: @escaping () -> Void) {
        guard let title = place.title,
              let locationName = place.locationName else {
            errorCompletion()
            return
        }
        let likedPlacesRef = databaseRef.child(self.userUID).child("likedPlaces")
        let likedPlaceRef = likedPlacesRef.child("\(title), \(locationName)")
        likedPlaceRef.removeValue { (error, ref) in
            if let _ = error {
                errorCompletion()
                return
            }
            completion()
        }
    }
    
    /// Метод для получения информации о том добавлен ли это заведение в избранные
    func isPlaceLiked(place: Place,
                      completion: @escaping (Bool) -> Void,
                      errorCompletion: @escaping () -> Void) {
        DispatchQueue.global(qos: .userInteractive).async {
            guard let title = place.title,
                  let locationName = place.locationName else {
                errorCompletion()
                return
            }
            let likedPlacesRef = self.databaseRef.child(self.userUID).child("likedPlaces")
            let likedPlaceRef = likedPlacesRef.child("\(title), \(locationName)")
            likedPlaceRef.observe(.value, with: { (snapshot) in
                if snapshot.childrenCount > 0 {
                    completion(true)
                } else {
                    completion(false)
                }
            })
        }
    }
    
    func getLikedPlaces(completion: @escaping ([FirebaseLikedPlace]) -> Void,
                        errorCompletion: @escaping () -> Void) {
        let likedPlacesRef = self.databaseRef.child(self.userUID).child("likedPlaces")
        var likedPlaces: [FirebaseLikedPlace] = []
        likedPlacesRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.childrenCount > 0 {
                for child in snapshot.children {
                    guard let array = (child as? DataSnapshot)?.value as? Dictionary<String, Any> else {
                        errorCompletion()
                        assertionFailure("Can not load liked places")
                        return
                    }
                    guard let locationName = array["locationName"] as? String,
                          let title = array["title"] as? String else {
                        assertionFailure("Something went wrong")
                        return
                    }
                    let likedPlace = FirebaseLikedPlace(locationName: locationName,
                                                        title: title)
                    likedPlaces.append(likedPlace)
                }
            }
            completion(likedPlaces)
        })
    }
}

// MARK: - Методы для работы с заказами

extension FirebaseDatabaseManager {
    /// Метод для загрузки данных в FirebaseDatabase.
    func uploadOrders(foodArray: [Food],
                      orderTime: String,
                      deliveryMethod: String,
                      completion: (() -> Void),
                      errorCompletion: (() -> Void)) {
        self.uploadOrderToRestaurant(foodArray: foodArray,
                                     orderTime: orderTime,
                                     deliveryMethod: deliveryMethod) {
            // Ошибка!
            errorCompletion()
        }
        self.uploadOrderToHistory(foodArray: foodArray,
                                  orderTime: orderTime,
                                  deliveryMethod: deliveryMethod) {
            // Ошибка!
            errorCompletion()
        }
        completion()
    }
    
    /// Метод для получения списка заказов из Firebase Database.
    func getOrders(completion: @escaping ([HistoryOrderEntity]) -> Void,
                   errorCompletion: @escaping () -> Void) {
        let ref = databaseRef.child(self.userUID).child("orders")
        var previousOrders: [HistoryOrderEntity] = []
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.childrenCount > 0 {
                for index in 0...snapshot.childrenCount-1 {
                    guard let array = snapshot.childSnapshot(forPath: "\(index)").value as? Dictionary<String, Any> else {
                        errorCompletion()
                        assertionFailure("Something went wrong")
                        return
                    }
                    guard let time = array["time"] as? String,
                          let food = array["food"] as? String,
                          let from = array["from"] as? String,
                          let newPrice = array["newPrice"] as? Double,
                          let price = array["price"] as? Double,
                          let imageURL = array["imageURL"] as? String else {
                        errorCompletion()
                        assertionFailure("Something went wrong")
                        return
                    }
                    let order = HistoryOrderEntity(time: time,
                                                   food: food,
                                                   from: from,
                                                   newPrice: newPrice,
                                                   price: price,
                                                   imageURL: imageURL)
                    previousOrders.append(order)
                }
            }
            // Чтобы показывать сначала последние заказы
            previousOrders = previousOrders.reversed()
            completion(previousOrders)
        })
    }
    
    /// Метод в completion возвращает количество сделанных пользователем заказов
    func getOrdersCount(completion: @escaping ((Int) -> Void)) {
        let ref = databaseRef.child(self.userUID).child("orders")
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            let childrenCount = Int(snapshot.childrenCount)
            completion(childrenCount)
        })
    }
    
    /// Загружает запись в firebase database для того, чтобы заведения могли видеть заказ
    private func uploadOrderToRestaurant(foodArray: [Food],
                                         orderTime: String,
                                         deliveryMethod: String,
                                         errorCompletion: (() -> Void)) {
        for food in foodArray {
            guard let foodName = food.foodName,
                  let restaurantAddress = food.address,
                  let restaurantName = food.placeName,
                  let price = food.newFoodPrice else {
                errorCompletion()
                return
            }
            let restaurant = "\(restaurantName), \(restaurantAddress)"
            let order = PlaceOrderEntity(time: timeManager.getCurrentTime(isForUser: false),
                                         foodName: foodName,
                                         price: price,
                                         deliveryMethod: deliveryMethod, orderTime: orderTime)
            // Этот блок добавляет записи в Firebase/Orders/название_Ресторана для того, чтобы рестораны могли его видеть
            let restaurantRef = databaseRef.child("orders").child("\(restaurant)")
            restaurantRef.child("\(order.time)").setValue(["food": order.foodName,
                                                           "price": order.price,
                                                           "orderedFrom": order.deliveryMethod,
                                                           "orderTime": order.orderTime])
        }
    }
    
    /// Загружает запись в firebase database для последующего просмотра историй заказов в профиле
    private func uploadOrderToHistory(foodArray: [Food],
                                      orderTime: String,
                                      deliveryMethod: String,
                                      errorCompletion: (() -> Void)) {
        for (index, food) in foodArray.enumerated() {
            guard let foodName = food.foodName,
                  let restaurantAddress = food.address,
                  let restaurantName = food.placeName,
                  let newPrice = food.newFoodPrice,
                  let price = food.foodPrice,
                  let imageURL = food.imageURL else {
                errorCompletion()
                return
            }
            let restaurant = "\(restaurantName), \(restaurantAddress)"
            let order = HistoryOrderEntity(time: timeManager.getCurrentTime(isForUser: true),
                                           food: foodName,
                                           from: restaurant,
                                           newPrice: newPrice,
                                           price: price,
                                           imageURL: imageURL)
            
            let userRef = databaseRef.child(self.userUID).child("orders")
            
            userRef.observeSingleEvent(of: .value, with: { (snapshot) in
                let newRefIndex = (Int(snapshot.childrenCount) + index)
                userRef.child("\(newRefIndex)").setValue(["time" : order.time,
                                                          "food" : order.food,
                                                          "from": order.from,
                                                          "newPrice": order.newPrice,
                                                          "price": order.price,
                                                          "imageURL": order.imageURL])
            })
        }
    }
}
