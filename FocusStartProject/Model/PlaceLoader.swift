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
    private let errorDescription = "Не удалось получить список заведений"

    func loadInitialData(completion: (([Place]) -> Void),
                         errorCompletion: ((String) -> Void)) {
        if self.places.isEmpty {
            guard let fileName = Bundle.main.url(forResource: "FoodPlaces", withExtension: "geojson"),
                  let artworkData = try? Data(contentsOf: fileName) else{
                errorCompletion(self.errorDescription)
                return
            }
            do {
                let features = try MKGeoJSONDecoder()
                    .decode(artworkData)
                    .compactMap{$0 as? MKGeoJSONFeature}
                let place = features.compactMap(Place.init)
                self.places.append(contentsOf: place)
                completion(self.places)
            } catch {
                errorCompletion(self.errorDescription)
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

    /// Сохраняет отсортированные по близости к пользователю заведения
    func setPlacesByLocation(places: [Place]) {
        self.places = places
    }
}
