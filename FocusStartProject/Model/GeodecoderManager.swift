//
//  GeodecoderManager.swift
//  FocusStartProject
//
//  Created by Андрей Шамин on 12/10/20.
//

import Foundation
import MapKit

protocol IGeodecoderManager {
    static func decodeAddress(location: CLLocationCoordinate2D,
                              completion: @escaping ((String) -> Void),
                              errorCompletion: @escaping ((String) -> Void))
}

final class GeodecoderManager: IGeodecoderManager {
    /// Преобразование location в строковое представление адреса
    static func decodeAddress(location: CLLocationCoordinate2D,
                              completion: @escaping ((String) -> Void),
                              errorCompletion: @escaping ((String) -> Void)) {
        let decoder: CLGeocoder = CLGeocoder()
        let loc: CLLocation = CLLocation(latitude: location.latitude,
                                         longitude: location.longitude)
        decoder.reverseGeocodeLocation(loc) { (placemarks, error) in
            if let error = error {
                errorCompletion(error.localizedDescription)
                return
            }
            if (placemarks?.count ?? 0) > 0 {
                guard let placemark = placemarks?[0] else {
                    return
                }
                var addressString : String = ""
                if let subLocality = placemark.subLocality {
                    addressString = addressString + subLocality + ", "
                }
                if let thoroughfare = placemark.thoroughfare {
                    addressString = addressString + thoroughfare + ", "
                }
                if let locality = placemark.locality {
                    addressString = addressString + locality + ", "
                }
                if let country = placemark.country {
                    addressString = addressString + country + ", "
                }
                if let postalCode = placemark.postalCode {
                    addressString = addressString + postalCode + " "
                }
                completion(addressString)
            }
        }
    }
}
