//
//  MainScreenPlacesCollectionViewDelegate.swift
//  FocusStartProject
//
//  Created by Андрей Шамин on 12/7/20.
//

import UIKit

protocol IMainScreenPlacesDelegate: class {
    func selectedCell(collectionView: UICollectionView, indexPath: IndexPath)
}

final class MainScreenPlacesCollectionViewDelegate: NSObject {

    // MARK: - Properties

    private weak var delegate: IMainScreenPlacesDelegate?

    // MARK: - Init

    init(withDelegate delegate: IMainScreenPlacesDelegate) {
        self.delegate = delegate
    }
}

// MARK: - UICollectionViewDelegate

extension MainScreenPlacesCollectionViewDelegate: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        delegate?.selectedCell(collectionView: collectionView, indexPath: indexPath)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension MainScreenPlacesCollectionViewDelegate: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(
            width: AppConstants.CollectionViewSize.mainScreenCollectionViewCellSize.width,
            height: AppConstants.CollectionViewSize.mainScreenCollectionViewCellSize.height)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        AppConstants.Constraints.collectionViewCellSpacing
    }
}
