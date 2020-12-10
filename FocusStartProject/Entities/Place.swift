//
//  Place.swift
//  FocusStartProject
//
//  Created by Андрей Шамин on 12/7/20.
//

import Foundation
import MapKit
import Contacts

final class Place: NSObject, MKAnnotation{
    // Для создания маркера на карте с координатами CLLocationCoordinate2D
    let title: String?
    let locationName: String?
    let discipline: String?
    let coordinate: CLLocationCoordinate2D
    let imagefile: String?
    let descriptionText: String?
    var distance: Double?
    let isSale: Bool?

    var mapItem: MKMapItem?{
        guard let location = locationName else{
            return nil
        }

        let addressDict = [CNPostalAddressStreetKey: location]
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDict)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = title
        return mapItem
    }

    init(title: String?,
         locationName: String?,
         discipline:String?,
         coordinate: CLLocationCoordinate2D,
         imagefile: String,
         descriptionText: String,
         distance: Double,
         isSale: Bool?){
        self.title = title
        self.locationName = locationName
        self.discipline = discipline
        self.coordinate = coordinate
        self.imagefile = imagefile
        self.descriptionText = descriptionText
        self.distance = distance
        self.isSale = isSale

        super.init()
    }

    init?(feature: MKGeoJSONFeature){
        guard let point = feature.geometry.first as? MKPointAnnotation,
            let propertiesData = feature.properties,
            let json = try? JSONSerialization.jsonObject(with: propertiesData),
            let properties = json as? [String:Any] else{
                return nil
        }

        title = properties["title"] as? String
        locationName = properties["location"] as? String
        discipline = properties["discipline"] as? String
        coordinate = point.coordinate
        imagefile = properties["imagefile"] as? String
        descriptionText = properties["descriptionText"] as? String
        distance = properties["distance"] as? Double
        isSale = properties["isSale"] as? Bool
        super.init()
    }

    var markerTintColor: UIColor  {
        switch discipline {
        case "Ресторан":
            return .red
        case "Кафе":
            return .red
        case "Фаст-фуд":
            return .red
        default:
            return .green
        }
    }

    var subtitle: String?{
        return locationName
    }
}

