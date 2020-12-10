//
//  PlaceLoader.swift
//  FocusStartProject
//
//  Created by Андрей Шамин on 12/7/20.
//

import MapKit

final class PlaceLoader {

    private var places: [Place] = []
    static let sharedInstance = PlaceLoader()

    func loadInitialData(completion: (([Place]) -> Void)) {
        if self.places.isEmpty {
            guard let fileName = Bundle.main.url(forResource: "FoodPlaces", withExtension: "geojson"),
                  let artworkData = try? Data(contentsOf: fileName) else{
                return
            }
            do{
                let features = try MKGeoJSONDecoder()
                    .decode(artworkData)
                    .compactMap{$0 as? MKGeoJSONFeature}
                let place = features.compactMap(Place.init)
                self.places.append(contentsOf: place)
                completion(self.places)
            }catch{
                print("Unexpected error: \(error)")
            }
        } else {
            completion(self.places)
        }
    }

    func getDisciplines() -> [String] {
        var disciplines: [String] = []
        for place in places {
            guard let discipline = place.discipline else { continue }
            if !disciplines.contains(discipline) {
                disciplines.append(discipline)
            }
        }
        return disciplines
    }

    func getPlacesForDiscpline(_ discpline: String) -> [Place] {
        var placesForDiscipline: [Place] = []
        for place in places {
            guard let placeDiscipline = place.discipline else { continue }
            if discpline == placeDiscipline {
                placesForDiscipline.append(place)
            }
        }
        return placesForDiscipline
    }
}
