//
//  MenuScreenCollectionViewDataSource.swift
//  FocusStartProject
//
//  Created by Андрей Шамин on 12/7/20.
//

import UIKit

final class MenuScreenCollectionViewDataSource: NSObject {

    // MARK: Properties

    var foodArray: [Food] = []
}

// MARK: UICollectionViewDataSource

extension MenuScreenCollectionViewDataSource: UICollectionViewDataSource{

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return foodArray.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: MenuCollectionViewCell.reuseIdentifier,
                for: indexPath) as? MenuCollectionViewCell
        else {
            fatalError("Something went wrong")
        }
        let food = foodArray[indexPath.row]
        cell.setupCell(forFood: food)
        return cell
    }
}
