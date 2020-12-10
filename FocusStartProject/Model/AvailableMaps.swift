//
//  AvailableMaps.swift
//  FocusStartProject
//
//  Created by Андрей Шамин on 12/7/20.
//

import MapKit

final class AvailableMaps {
    static func getAvailableMaps(withLocation location: CLLocationCoordinate2D) -> [(String, URL)] {
        let latitude = location.latitude
        let longitude = location.longitude

        let appleURL = "http://maps.apple.com/?daddr=\(latitude),\(longitude)"
        let googleURL = "comgooglemaps://?daddr=\(latitude),\(longitude)&directionsmode=driving"
        let wazeURL = "waze://?ll=\(latitude),\(longitude)&navigate=false"
        let yandexURL = "yandexmaps://maps.yandex.ru/?ll=\(latitude),\(longitude)&z=12"

        var availableMaps = [("Apple Maps", URL(string:appleURL)!)]


        if let googleItemURL = URL(string: googleURL) {
            let googleItem = ("Google Map", googleItemURL)

            if UIApplication.shared.canOpenURL(googleItem.1) {
                availableMaps.append(googleItem)
            }
        }

        if let wazeItemURL = URL(string: wazeURL) {
            let wazeItem = ("Waze", wazeItemURL)
            if UIApplication.shared.canOpenURL(wazeItem.1) {
                availableMaps.append(wazeItem)
            }
        }

        if let yandexItemURL = URL(string:yandexURL) {
            let yandexItem = ("Яндекс", yandexItemURL)
            if UIApplication.shared.canOpenURL(yandexItem.1) {
                availableMaps.append(yandexItem)
            }
        }

        return availableMaps
    }
}
