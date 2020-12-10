//
//  MainScreenPlacesCollectionViewDataSource.swift
//  FocusStartProject
//
//  Created by Андрей Шамин on 12/7/20.
//

import UIKit

final class MainScreenPlacesCollectionViewDataSource: NSObject {

    // MARK: Properties
    var placesArray: [Place] = []
}

// MARK: UICollectionViewDataSource
extension MainScreenPlacesCollectionViewDataSource: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return placesArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: MainScreenCollectionViewCell.reuseIdentifier,
                for: indexPath) as? MainScreenCollectionViewCell
        else {
            fatalError("Something went wrong")
        }

        let place = placesArray[indexPath.row]
        cell.setupCell(forPlace: place)

        return cell
    }
}
